//
//  KTLMappedCardioExerciseViewController.m
//  Kinetical
//
//  Created by Bob Law on 2/2/14.
//  Copyright (c) 2014 Bob Law Productions. All rights reserved.
//

#import "KTLMappedCardioExerciseViewController.h"
#import <dispatch/dispatch.h>

@interface KTLMappedCardioExerciseViewController ()

@end

@implementation KTLMappedCardioExerciseViewController

@synthesize cExercise, mapView, crumbView, crumbs, detailExerciseBkg, toggleMileMarkersButton, cardioExerciseTableView, rezoomButton, sliderCell, exerciseStatsSlider, currentSpeedLabel, currentPaceLabel, dist, selectedRow, sliderPoint, cardioExercisePickerView, isPickerViewShowing, nameLabel, datePicker, dateLabel, isDatePickerViewShowing, isNamePickerViewShowing, finishedAnnotationCoord, oldLocation, showStatsButton, exerciseName, exerciseStatsArray, mileAnnotations, location, US, finishAnnotationCoord, cardioExercises, cDate, cDistance, cPace, cSpeed, averagePace, averageSpeed, numberOfSpeedReadings, speedDivider, paceDivider, minLatitude, minLongitude, maxLatitude, maxLongitude, routecount, fetchRequest, managedObjectContext, standardDefaults, milesTimeArray, fastestPaceInterval, mapHUDView, maxSpeedNumber, firstMapImageRender;


- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    if (!firstMapImageRender) {
        [self.mapView removeAnnotations:mileAnnotations];
        UIImage *mapImage = [self.mapView convertViewToImage];
        [self.mapView addAnnotations:mileAnnotations];
        
        NSManagedObject *object = cExercise;
        NSData *mapImageData =  UIImagePNGRepresentation(mapImage);
        [object setValue:mapImageData forKey:@"annotations"];
        NSError *error;
        managedObjectContext = [self managedObjectContext];
        [managedObjectContext save:&error];
        firstMapImageRender = YES;
    }
}



- (NSString *) getDifferenceBetweenTime:(NSString *)nowMileTime from:(NSString *)previousMileTime{
    
    NSDateFormatter *firstDateFormatter = [[NSDateFormatter alloc] init];
    if ([nowMileTime length] <= 5) {
        [firstDateFormatter setDateFormat: @"mm:ss"];
    } else {
        [firstDateFormatter setDateFormat: @"HH:mm:ss"];
    }
    
    
    NSDateFormatter *secondDateFormatter = [[NSDateFormatter alloc] init];
    if ([previousMileTime length] <= 5) {
        [secondDateFormatter setDateFormat: @"mm:ss"];
    } else {
        [secondDateFormatter setDateFormat: @"HH:mm:ss"];
    }
    
    
    
    NSDate * now = [firstDateFormatter dateFromString:nowMileTime];
    NSDate *previous = [secondDateFormatter dateFromString:previousMileTime];
    
    NSTimeInterval difference = [now timeIntervalSinceDate:previous];
    
    [self getFastestMilePace:difference];
    
    NSInteger ti = (NSInteger)difference;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    NSString *returnString;
    if (hours == 0) {
        returnString =  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
    } else {
        returnString =  [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    if ([[returnString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        return [returnString substringFromIndex:1];
    } else{
        return returnString;
    }
}

- (void)getFastestMilePace:(NSTimeInterval)interval{
    
    
    if (interval < fastestPaceInterval) {
        fastestPaceInterval = interval;
        
        NSInteger ti = (NSInteger)fastestPaceInterval;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600);
        
        if (hours == 0) {
            if (minutes < 10) {
                [mapHUDView setFastestPace:[NSString stringWithFormat:@"%1li:%02li", (long)minutes, (long)seconds]];
            } else {
                [mapHUDView setFastestPace:[NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds]];
            }
        } else {
            if (hours < 10) {
                [mapHUDView setFastestPace:[NSString stringWithFormat:@"%1li:%02li:%02li", (long)hours, (long)minutes, (long)seconds]];
            } else {
                [mapHUDView setFastestPace:[NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds]];
            }
        }
    }
}

- (IBAction)rezoomButtonPressed:(id)sender {
    
    if ([mapView.annotations count] == 0) return;

    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    
    topLeftCoord.longitude = minLongitude;
    topLeftCoord.latitude = maxLatitude;
    bottomRightCoord.longitude = maxLongitude;
    bottomRightCoord.latitude = minLatitude;
    
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.35;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.35;
    
    // Add a little extra space on the sides
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
}
- (IBAction)toggleMileMarkersButtonPressed:(id)sender {
    
   
    toggleMileMarkersButton.selected = !toggleMileMarkersButton.isSelected;
    
    if (toggleMileMarkersButton.selected) {

        [self.mapView removeAnnotations:mileAnnotations];
    } else{

        [self.mapView addAnnotations:mileAnnotations];
    }
}


#pragma mark TableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if (section == 1){
        return 4;
    } else if(section == 2){
        if ([milesTimeArray count] == 0) {
            return 1;
        } else{
            return [milesTimeArray count];
        }
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 320, 32)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    headerLabel.font = [UIFont systemFontOfSize:18];
    headerLabel.textColor = [UIColor lightGrayColor];
    // headerLabel.textAlignment = UITextAlignmentCenter;
    
    
    if (section == 0) {
        headerLabel.text = @"Map";
    } else if (section == 1) {
        headerLabel.text = @"Exercise Stats";
    } else if(section == 2){
        headerLabel.text = @"Mile Times";
    }
    
    [headerView addSubview:headerLabel];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 32;
    } else if(section == 3){
        return 15;
    }else {
        return 32.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             return 250;
        } else {
            return 80;
        }
    } else if(indexPath.section == 1 ){
        return 60;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            [cell addSubview:mapView];
        } else {

            [cell addSubview:exerciseStatsSlider];
            [cell addSubview:rezoomButton];
            [cell addSubview:toggleMileMarkersButton];
            [cell addSubview:currentSpeedLabel];
            [cell addSubview:currentPaceLabel];
   
        }
        
        
    } else if (indexPath.section == 1) {
        
        UILabel *leftCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
        leftCellLabel.textAlignment = UITextAlignmentCenter;
        leftCellLabel.adjustsFontSizeToFitWidth = YES;
        UILabel *rightCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 60)];
        rightCellLabel.textAlignment = UITextAlignmentCenter;
        rightCellLabel.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:leftCellLabel];
        [cell addSubview:rightCellLabel];
        
        UIView *lineSegment = [[UIView alloc] initWithFrame:CGRectMake(160, 5, 1, 50)];
        lineSegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        if(indexPath.row == 0){
            leftCellLabel.text = cExercise.name;
            leftCellLabel.font = [UIFont systemFontOfSize:34];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:cExercise.date];

            rightCellLabel.text = dateString;
            
        }
        if(indexPath.row == 1){
            
            leftCellLabel.attributedText = mapHUDView.distanceLabel.attributedText;
            rightCellLabel.adjustsFontSizeToFitWidth = YES;
            rightCellLabel.attributedText = mapHUDView.timerLabel.attributedText;
            [cell addSubview:lineSegment];
            
        }
        if(indexPath.row == 2){
            
            leftCellLabel.numberOfLines = 2;
            rightCellLabel.numberOfLines = 2;
            leftCellLabel.attributedText = mapHUDView.averageSpeedLabel.attributedText;
            rightCellLabel.attributedText = mapHUDView.maxSpeedLabel.attributedText;
            
            [cell addSubview:lineSegment];
            
        }
        
        if(indexPath.row == 3){
            
            leftCellLabel.numberOfLines = 2;
            rightCellLabel.numberOfLines = 2;
            leftCellLabel.attributedText = mapHUDView.averagePaceLabel.attributedText;
            rightCellLabel.attributedText = mapHUDView.fastestPaceLabel.attributedText;
            
            [cell addSubview:lineSegment];
            
        }
 
    }else if (indexPath.section == 2){
        
        cell.textLabel.font = [UIFont systemFontOfSize:25];
        

        if([milesTimeArray count]>0){
            if (US) {
                cell.textLabel.text = [NSString stringWithFormat:@"Mile %ld", indexPath.row+1];
            } else{
                cell.textLabel.text = [NSString stringWithFormat:@"Km %ld", indexPath.row+1];
            }
            UILabel *mileTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
            mileTimeLabel.textAlignment = UITextAlignmentRight;
            mileTimeLabel.font =  [UIFont systemFontOfSize:25];
            
            NSArray *splitArray = [[milesTimeArray objectAtIndex:indexPath.row] componentsSeparatedByString:@"/"];
            
            if (indexPath.row == 0) {
                mileTimeLabel.text = [splitArray objectAtIndex:0];
            } else{
                mileTimeLabel.text = [splitArray objectAtIndex:1];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Total Time: %@",[splitArray objectAtIndex:0]];
            }
            cell.accessoryView = mileTimeLabel;
            
        } else{
            
            cell.textLabel.text = @"No Mile Data";
            
        }
    } else{
        
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        deleteLabel.text = @"Delete Exercise";
        deleteLabel.textColor = [UIColor redColor];
        deleteLabel.font = [UIFont systemFontOfSize:22];
        deleteLabel.textAlignment = UITextAlignmentCenter;
        
        [cell addSubview:deleteLabel];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you wish to delete this exercise?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Exercise" otherButtonTitles:nil,nil];
        [actionSheet showFromTabBar:self.view];
        
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        managedObjectContext = [self managedObjectContext];
        NSManagedObject *managedCardio = cExercise;
        [managedObjectContext deleteObject:managedCardio];
        NSError *error;
        [managedObjectContext save:&error];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


@end
