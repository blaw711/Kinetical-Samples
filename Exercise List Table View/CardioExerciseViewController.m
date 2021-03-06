//
//  IndividualWorkoutViewController.m
//  Fit Track
//
//  Created by Bob Law on 10/5/13.
//  Copyright (c) 2013 Bob Law Productions. All rights reserved.
//

#import "CardioExerciseViewController.h"
#import "MappedCardioExerciseViewController.h"
#import "IndividualCardioExerciseViewController.h"
#import "KTLMappedCardioExerciseViewController.h"
#import "Cardio_Exercise.h"
#import "Weight_Exercise.h"
#import "NSDate+convenience.h"
#import <dispatch/dispatch.h>
#import "NSString+TimeFormat.h"


@interface CardioExerciseViewController ()

@end

@implementation CardioExerciseViewController

@synthesize exercisename, exercises, tableView, selectedExercises, totalDistanceLabel, totalDistanceString, totalTimeFieldLabel, totalTimeString, longestDistanceLabel, longestDistanceString, titleLabel, longestTimeLabel, longestTimeString, averagePaceLabel, averagePaceString, bestPaceLabel, bestPaceString, distanceNumTimeCell, longestDistanceDate, longestTimeDate, bestPaceDate, managedObjectContext, didViewLoad, US, timePeriodSegmentedControl, standardDefaults, previousNumberOfSelectedExercises, selectedExercise;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Records", exercisename];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    timePeriodSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Month", @"6 Months", @"Year", @"All Time", nil]];
    //  [timePeriodSegmentedControl setFrame:CGRectMake(0, 0, 321, 44)];
    timePeriodSegmentedControl.tintColor = [UIColor colorWithRed:(15.0/255.0) green:(97.0/255.0) blue:(155.0/255.0) alpha:1];
    timePeriodSegmentedControl.backgroundColor = [UIColor whiteColor];
    timePeriodSegmentedControl.selectedSegmentIndex = 0;
    [timePeriodSegmentedControl addTarget:self
                                   action:@selector(changesec:)
                         forControlEvents:UIControlEventValueChanged];
    
    longestTimeDate = nil, longestDistanceDate = nil, bestPaceDate = nil;
    
    selectedExercises = [NSMutableArray array];
    
    
    
    longestTimeDate = nil;
    longestTimeDate = nil;
    bestPaceDate = nil;
    
    
    standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[standardDefaults objectForKey:@"Units"] isEqualToString:@"US"]) {
        US = YES;
        
        totalDistanceLabel.text = @"0.00 miles";
        totalTimeFieldLabel.text = @"00:00:00";
        longestDistanceLabel.text = @"0.00 miles";
        longestTimeDate = nil;
        longestTimeLabel.text = @"00:00:00";
        longestTimeDate = nil;
        bestPaceLabel.text = @"0.00 per mile";
        bestPaceDate = nil;
        averagePaceLabel.text = @"0.00 per mile";
    } else{
        US = NO;
        
        totalDistanceLabel.text = @"0.00 km";
        totalTimeFieldLabel.text = @"00:00:00";
        longestDistanceLabel.text = @"0.00 km";
        longestTimeDate = nil;
        longestTimeLabel.text = @"00:00:00";
        longestTimeDate = nil;
        bestPaceLabel.text = @"0.00 per km";
        bestPaceDate = nil;
        averagePaceLabel.text = @"0.00 per km";
    }

    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:15.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [self setUpCoreData];
        [self getExercisesForPastMonth];
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if([selectedExercises count] > 0){
                
                [self getLongestTime];
                [self calculatePaceMeasurements];
                [self calculateTotalDistanceForSelection];
                [self calculateTotalTimeFromSelection];
                [self findExerciseWithMaxDistance];
            }
            titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedExercises count]];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];

           
        });
    });

    didViewLoad = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([[standardDefaults objectForKey:@"Units"] isEqualToString:@"US"]) {
        
        US = YES;
        
    } else{
        
        US = NO;
        
    }
    
   if(!didViewLoad){
       
      // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           //Here your non-main thread.
           previousNumberOfSelectedExercises = [NSNumber numberWithInteger:[selectedExercises count]];
           //NSLog (@"Hi, I'm new thread");
           [self setUpCoreData];
           [selectedExercises removeAllObjects];
           if (timePeriodSegmentedControl.selectedSegmentIndex == 0) {
               [self getExercisesForPastMonth];
           } else if(timePeriodSegmentedControl.selectedSegmentIndex == 1){
               [self getExercisesForPast6Months];
           } else if (timePeriodSegmentedControl.selectedSegmentIndex == 2){
               [self getExercisesForPastYear];
           } else if (timePeriodSegmentedControl.selectedSegmentIndex == 3){
               selectedExercises = exercises;
           }
       
       if([selectedExercises count] > 0){
           
           [self getLongestTime];
           [self calculatePaceMeasurements];
           [self calculateTotalDistanceForSelection];
           [self calculateTotalTimeFromSelection];
           [self findExerciseWithMaxDistance];
       }
       titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedExercises count]];
       

       
       if ([selectedExercises count] > [previousNumberOfSelectedExercises integerValue]) {
           
           if([previousNumberOfSelectedExercises intValue] == 0){
               [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
           }else{
               NSMutableArray *addedIndexPaths = [NSMutableArray new];
               for (int i = (int)[selectedExercises count] - [previousNumberOfSelectedExercises intValue]; i > 0; i--) {
                   [addedIndexPaths addObject:[NSIndexPath indexPathForRow:i-1 inSection:2]];
               }
               [tableView insertRowsAtIndexPaths:[NSArray arrayWithArray:addedIndexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
           }
           
       }
       if ([selectedExercises count] < [previousNumberOfSelectedExercises integerValue]) {
           if ([tableView indexPathForSelectedRow]) {
               [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
           }
           
       }
       if ([selectedExercises count] == [previousNumberOfSelectedExercises integerValue]) {

           if (![selectedExercise.date isEqual:[[selectedExercises objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"date"]]) {
               [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];

           }else {
               [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tableView indexPathForSelectedRow]] withRowAnimation:UITableViewRowAnimationAutomatic];
           }
        
       }
       
       if ([tableView indexPathForSelectedRow]) {
           [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
       }

       
        if (US && [selectedExercises count] == 0) {
            
            totalDistanceLabel.text = @"0.00 miles";
            totalTimeFieldLabel.text = @"00:00:00";
            longestDistanceLabel.text = @"0.00 miles";
            longestTimeLabel.text = @"00:00:00";
            bestPaceLabel.text = @"0.00 per mile";
            averagePaceLabel.text = @"0.00 per mile";
            
        } else if([selectedExercises count] == 0){
            
            totalDistanceLabel.text = @"0.00 km";
            totalTimeFieldLabel.text = @"00:00:00";
            longestDistanceLabel.text = @"0.00 km";
            longestTimeLabel.text = @"00:00:00";
            bestPaceLabel.text = @"0.00 per km";
            averagePaceLabel.text = @"0.00 per km";
        }
       
       
        
    }
    didViewLoad = NO;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void) setUpCoreData {
    
    managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Cardio_Exercise"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.exercisename];
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"date"
                                                          ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:srt]];
    self.exercises = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 5;
    }
    else {
        if ([selectedExercises count] > 0) {
            return [self.selectedExercises count];
        }else{
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if ([selectedExercises count] > 0) {
            if ([[[selectedExercises objectAtIndex:indexPath.row] valueForKey:@"isMapped"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                return 70;
            }else{
                return  50;
            }
        } else{
            return 50;
        }
    }
    
    return 44;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 290, 30)];
    if (section == 0) {
        [headerView setFrame:CGRectMake(15, 5, 290, 40)];
    }
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    headerLabel.font = [UIFont systemFontOfSize:18];
    headerLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.];
    headerLabel.adjustsFontSizeToFitWidth = YES;
    
    if (section == 0) {
        headerLabel.text = @"Time Period";
    } else if (section == 1) {
        headerLabel.text = [NSString stringWithFormat:@"%@ Stats", exercisename];
    } else if(section == 2){
        headerLabel.text =[NSString stringWithFormat:@"%@ Records", exercisename];
    }
    
    [headerView addSubview:headerLabel];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [timePeriodSegmentedControl setFrame:CGRectMake(.5, 0, 322, 44)];
       
        [cell.contentView addSubview: timePeriodSegmentedControl];
        
    }else if(indexPath.section == 1){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];

        if (indexPath.row == 0) {
           
            cell = distanceNumTimeCell;
        
            
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Longest Distance";
            longestDistanceLabel.textAlignment = NSTextAlignmentRight;
            longestDistanceLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = longestDistanceLabel;
            cell.detailTextLabel.text = longestDistanceDate;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Longest Time";
            longestTimeLabel.textAlignment = NSTextAlignmentRight;
            longestTimeLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = longestTimeLabel;
            cell.detailTextLabel.text = longestTimeDate;

        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Best Pace";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            bestPaceLabel.textAlignment = NSTextAlignmentRight;
            bestPaceLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = bestPaceLabel;
            cell.detailTextLabel.text = bestPaceDate;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Average Pace";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            averagePaceLabel.textAlignment = NSTextAlignmentRight;
            averagePaceLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryView = averagePaceLabel;
            
        }
       /* if (indexPath.row == 7) {
            cell.textLabel.text = @"Graph Record Progress";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"of currently selected time period";
            
        }*/
    }
    
    
    
    else if (indexPath.section == 2) {
        
        if ([selectedExercises count] == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text =[NSString stringWithFormat:@"No %@ records in this time period", exercisename];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.detailTextLabel.text = @"Be Kinetical!";
            
        } else{
            
            Cardio_Exercise *exer = [self.selectedExercises objectAtIndex:indexPath.row];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:[exer valueForKey:@"date"]];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@", dateString];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
            
            NSNumber *isMapped = [exer valueForKey:@"isMapped"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if ([isMapped isEqualToNumber:[NSNumber numberWithBool:YES]]){
        
                UIImage *mapImage = [[UIImage alloc] initWithData:[exer valueForKey:@"annotations"] scale:.2f];
                [cell.imageView setImage:mapImage];
                
            } else{
                
                
            }
            
            double distance = [[exer valueForKey:@"distance"] doubleValue];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            if (US) {
                cell.detailTextLabel.text = [exer getPaceForExercise];//[NSString stringWithFormat:@"%.2f miles - %@ - Pace: %@", distance, [NSString getFormattedTimeStringFromSeconds:[exer getNumberOfSecondsFromTime]], [exer getPaceForExercise]];
                
            } else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f km - %@", distance * 1.60934, [NSString getFormattedTimeStringFromSeconds:[exer getNumberOfSecondsFromTime]]];
            }
            
        }
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return NO;
    } else {
        if ([selectedExercises count] == 0) {
            return NO;
        } else{
            return YES;
        }
        
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        [self.managedObjectContext deleteObject:[selectedExercises objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        // Save the object to persistent store
        [managedObjectContext save:&error];
        
        
        
        [selectedExercises removeObjectAtIndex:indexPath.row];

        if ([selectedExercises count] != 0) {
            NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
            NSArray *array = [NSArray arrayWithObject:iPath];
            [self.tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationLeft];
        } else{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Cardio_Exercise"];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", self.exercisename];
        
        self.exercises = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.exercises = [[exercises reverseObjectEnumerator] allObjects];

        
        
        if([selectedExercises count] > 0){
            
            titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedExercises count]];
            [self calculateTotalDistanceForSelection];
            [self findExerciseWithMaxDistance];
            [self getLongestTime];
            [self calculatePaceMeasurements];
            [self calculateTotalTimeFromSelection];
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];

            
        } else if([selectedExercises count] == 0){
            
            titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedExercises count]];
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];


            
            if (US) {
                
                totalDistanceLabel.text = @"0.00 miles";
                totalTimeFieldLabel.text = @"00:00:00";
                longestDistanceLabel.text = @"0.00 miles";
                longestTimeLabel.text = @"00:00:00";
                bestPaceLabel.text = @"0.00 per mile";
                averagePaceLabel.text = @"0.00 per mile";
                
            } else{
                
                totalDistanceLabel.text = @"0.00 km";
                totalTimeFieldLabel.text = @"00:00:00";
                longestDistanceLabel.text = @"0.00 km";
                longestTimeLabel.text = @"00:00:00";
                bestPaceLabel.text = @"0.00 per km";
                averagePaceLabel.text = @"0.00 per km";
            }
        }
    
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
 
     if([segue.identifier isEqualToString:@"sample"]){
         
        KTLMappedCardioExerciseViewController *mappedCardioExerciseViewController = segue.destinationViewController;
        Cardio_Exercise *cardio = [self.selectedExercises objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        mappedCardioExerciseViewController.cExercise = cardio;
        mappedCardioExerciseViewController.title = mappedCardioExerciseViewController.cExercise.name;
    }
     if([segue.identifier isEqualToString:@"cardioStats"]){
         
         IndividualCardioExerciseViewController *individualCardioExerciseViewController = segue.destinationViewController;
         Cardio_Exercise *cardio = [self.selectedExercises objectAtIndex:[self.tableView indexPathForSelectedRow].row];
         individualCardioExerciseViewController.cExercise = cardio;
     }
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 8) {
        [self performSegueWithIdentifier:@"showgraph" sender:self.view];
    }
    if (indexPath.section == 2 && [selectedExercises count] > 0) {
        selectedExercise = [self.selectedExercises objectAtIndex:indexPath.row];
        if ([[[self.selectedExercises objectAtIndex:indexPath.row] valueForKey:@"isMapped"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
             [self performSegueWithIdentifier:@"sample" sender:self.view];
        } else{
            [self performSegueWithIdentifier:@"cardioStats" sender:self.view];
        }
    }
}

-(void) calculateTotalDistanceForSelection {
    
    double totalSelectedDistance = 0;
    for(int i = 0; i < [selectedExercises count]; i++){
        Cardio_Exercise *exer = [selectedExercises objectAtIndex:i];
        totalSelectedDistance += [exer.distance doubleValue];
    }
    if (US) {
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles", totalSelectedDistance];
    } else{
        totalDistanceLabel.text = [NSString stringWithFormat:@"%.2f km", totalSelectedDistance * 1.60934];
    }
}

-(void) findExerciseWithMaxDistance {
    
    double maxDistance = 0;
    NSDate *maxDistanceDate;
    for (int i = 0; i < [selectedExercises count]; i++) {
        
        Cardio_Exercise *exer = [selectedExercises objectAtIndex:i];
        
        if([exer.distance doubleValue] > maxDistance){
            
            maxDistance = [exer.distance doubleValue];
            maxDistanceDate = exer.date;
            
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:maxDistanceDate];
    if (US) {
        longestDistanceLabel.text = [NSString stringWithFormat:@"%.2f miles",maxDistance];
    } else {
        longestDistanceLabel.text = [NSString stringWithFormat:@"%.2f km",maxDistance * 1.60934];
    }
    longestDistanceDate = [NSString stringWithFormat:@"on %@",dateString];

}

-(void) calculateTotalTimeFromSelection{
    
    int sec = 0;
    for(Cardio_Exercise *exer in selectedExercises){
        sec+= [exer getNumberOfSecondsFromTime];
    }
    
    totalTimeFieldLabel.text = [NSString getFormattedTimeStringFromSeconds:sec];
}

-(void) getLongestTime {
    int sec = 0, maxSec = 0;
    NSDate *maxDate;
    for(Cardio_Exercise *exer in selectedExercises){
        
        sec = [exer getNumberOfSecondsFromTime];
        
        if (sec >= maxSec) {
            maxSec = sec;
            maxDate = exer.date;
        }
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:maxDate];
    longestTimeLabel.text = [NSString getFormattedTimeStringFromSeconds:maxSec];
    longestTimeDate = [NSString stringWithFormat:@"on %@",dateString];
}

-(void) calculatePaceMeasurements {
    //Set up for avg pace
    int sec = 0, min = 0, hour = 0, minSec = MAXFLOAT, totSec = 0;
    NSDate *paceDate;
    NSString *unit;
    
    for(Cardio_Exercise *exer in selectedExercises){
        NSArray *splitArray = [exer.time componentsSeparatedByString:@":"];
        sec = 0, min = 0, hour = 0;
        if ([splitArray count] == 3) {
            hour = [[splitArray objectAtIndex:0] intValue];
            min = [[splitArray objectAtIndex:1] intValue];
            sec = [[splitArray objectAtIndex:2] intValue];
        }else{
            min = [[splitArray objectAtIndex:0] intValue];
            sec = [[splitArray objectAtIndex:1] intValue];
        }
        
        hour = hour * 60 * 60;
        min = min * 60;
      
        if (US) {
            sec = (sec + min + hour);
            sec= sec/[exer.distance doubleValue];
            

            unit = @"mile";
        } else{
            sec = (sec + min + hour)/([exer.distance doubleValue]*1.60934);
            unit = @"km";
        }
        
       // NSLog(@"sec %d", sec);

        totSec += sec;
       // if () {
       //     minSec = sec;//2.8 50
       // }
        if (sec <= minSec) {
            minSec = sec;
            paceDate = exer.date;
        }
    }
    
    int avgPace = totSec/[selectedExercises count];
   // NSLog(@"AVGPACE %d", avgPace);
    int seconds = avgPace  % 60;
    int minutes = (avgPace / 60) % 60;
    int hours = avgPace / 3600;
    bool minStringBool = NO, secStringBool = NO;
    NSString *minString, *secString;
    
    if (minutes < 10) {
        minString = [NSString stringWithFormat:@"0%d", minutes];
        minStringBool = YES;
    }
    
    if (seconds < 10) {
        secString = [NSString stringWithFormat:@"0%d", seconds];
        secStringBool = YES;
    }
    
    if (hours > 0) {
        if (secStringBool && minStringBool) {
            averagePaceLabel.text = [NSString stringWithFormat:@"%d:%@:%@ per %@", hours, minString, secString, unit];
        }
        else if (secStringBool){
            averagePaceLabel.text = [NSString stringWithFormat:@"%d:%d:%@ per %@", hours, minutes, secString, unit];
        }
        else if (minStringBool){
            averagePaceLabel.text = [NSString stringWithFormat:@"%d:%@:%d per %@", hours, minString, seconds, unit];
        } else {
        averagePaceLabel.text = [NSString stringWithFormat:@"%d:%d:%d per %@", hours, minutes, seconds, unit];
        }
                                 
    } else if(minutes > 0){
        
        if (secStringBool){
            averagePaceLabel.text = [NSString stringWithFormat:@"%d:%@ per %@", minutes, secString, unit];
        }else {
            averagePaceLabel.text = [NSString stringWithFormat:@"%d:%d per %@", minutes, seconds, unit];
        }
        
    } else if(seconds > 0){
        if (secStringBool){
            averagePaceLabel.text = [NSString stringWithFormat:@"0:%@ per %@", secString, unit];
        }
        else {
            averagePaceLabel.text = [NSString stringWithFormat:@"0:%d per %@", seconds, unit];
        }
    }
    if([averagePaceLabel.text isEqualToString:@"Label"]){
        averagePaceLabel.text = @"Not enough data to calculate, you may have an exercise with no distance";
    }
    //Setup for best pace
    seconds = minSec  % 60;
    minutes = (minSec / 60) % 60;
    hours = minSec / 3600;
    minStringBool = NO, secStringBool = NO;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:paceDate];
    bestPaceDate = [NSString stringWithFormat:@"on %@",dateString];


    if (minutes < 10) {
        minString = [NSString stringWithFormat:@"0%d", minutes];
        minStringBool = YES;
    }
    
    if (seconds < 10) {
        secString = [NSString stringWithFormat:@"0%d", seconds];
        secStringBool = YES;
    }
    
    
    
    if (hours > 0) {
        if (secStringBool && minStringBool) {
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%@:%@ per %@", hours, minString, secString, unit];
        }
        else if (secStringBool){
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%d:%@ per %@", hours, minutes, secString, unit];
        }
        else if (minStringBool){
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%@:%d per %@", hours, minString, seconds, unit];
        } else {
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%d:%d per %@", hours, minutes, seconds, unit];
        }
        
    } else if(minutes > 0){

        if (secStringBool){
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%@ per %@", minutes, secString, unit];
        }
        else {
            bestPaceLabel.text = [NSString stringWithFormat:@"%d:%d per %@", minutes, seconds, unit];
        }
        
    } else if(seconds > 0){
        if (secStringBool){
            bestPaceLabel.text = [NSString stringWithFormat:@"0:%@ per %@", secString, unit];
        }
        else {
            bestPaceLabel.text = [NSString stringWithFormat:@"0:%d per %@", seconds, unit];
        }
    }

}

-(void) getExercisesForPastMonth {
   

    for(int i = 0; i < [exercises count]; i++){
        
        NSDate *someDate = [[exercises objectAtIndex:i] valueForKey:@"date"];
        NSDate *oneMonthAgo = [NSDate dateWithTimeInterval:-2592000 sinceDate:[NSDate date]];
        if ([someDate compare:oneMonthAgo] == NSOrderedDescending) {
            [selectedExercises addObject:[exercises objectAtIndex:i]];
        }
    }
}

-(void) getExercisesForPast6Months {
    

    for(int i = 0; i < [exercises count]; i++){
        
        NSDate *someDate = [[exercises objectAtIndex:i] valueForKey:@"date"];
        NSDate *oneMonthAgo = [NSDate dateWithTimeInterval:-15768000 sinceDate:[NSDate date]];
        if ([someDate compare:oneMonthAgo] == NSOrderedDescending) {
            [selectedExercises addObject:[exercises objectAtIndex:i]];
        }
    }
}

-(void) getExercisesForPastYear {
    
    for(int i = 0; i < [exercises count]; i++){
      
        NSDate *someDate = [[exercises objectAtIndex:i] valueForKey:@"date"];
        NSDate *oneMonthAgo = [NSDate dateWithTimeInterval:-31536000 sinceDate:[NSDate date]];
        if ([someDate compare:oneMonthAgo] == NSOrderedDescending) {
            [selectedExercises addObject:[exercises objectAtIndex:i]];
        }
    }
}



- (IBAction)changesec:(id)sender {
    
    int selectedExercisesCount = (int)[selectedExercises count];
    
    selectedExercises = [NSMutableArray array];
    
    if (timePeriodSegmentedControl.selectedSegmentIndex == 0) {
        
        [self getExercisesForPastMonth];
        
    }else if (timePeriodSegmentedControl.selectedSegmentIndex == 1) {
        
        [self getExercisesForPast6Months];
        
    }else if (timePeriodSegmentedControl.selectedSegmentIndex == 2) {
        
        [self getExercisesForPastYear];
        
    }else if (timePeriodSegmentedControl.selectedSegmentIndex == 3) {
        
        selectedExercises = exercises;
    }
    
    if([selectedExercises count] > 0){
        
        titleLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[selectedExercises count]];
        [self calculateTotalDistanceForSelection];
        [self findExerciseWithMaxDistance];
        [self getLongestTime];
        [self calculatePaceMeasurements];
        [self calculateTotalTimeFromSelection];
        
    }
    else{
        longestDistanceDate = nil;
        bestPaceDate = nil;
        longestTimeDate = nil;
        if (US) {
            titleLabel.text = @"0";
            
            totalDistanceLabel.text = @"0.00 miles";
            totalTimeFieldLabel.text = @"00:00:00";
            longestDistanceLabel.text = @"0.00 miles";
            longestTimeLabel.text = @"00:00:00";
            bestPaceLabel.text = @"0.00 per mile";
            averagePaceLabel.text = @"0.00 per mile";
            
        } else{
            titleLabel.text = @"0";
            
            totalDistanceLabel.text = @"0.00 km";
            totalTimeFieldLabel.text = @"00:00:00";
            longestDistanceLabel.text = @"0.00 km";
            longestTimeLabel.text = @"00:00:00";
            bestPaceLabel.text = @"0.00 per km";
            averagePaceLabel.text = @"0.00 per km";
        }
    }
    
    if ([selectedExercises count] != selectedExercisesCount) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    }
    [tableView reloadData];
}

@end
