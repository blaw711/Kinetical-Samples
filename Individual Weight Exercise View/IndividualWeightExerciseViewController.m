//
//  IndividualWeightExerciseViewController.m
//  Kinetical
//
//  Created by Bob Law on 11/19/13.
//  Copyright (c) 2013 Bob Law Productions. All rights reserved.
//

#import "IndividualWeightExerciseViewController.h"
#import "Weight_Exercise.h"
#import "WeightExerciseName.h"
#import "WeightExerciseViewController.h"

@interface IndividualWeightExerciseViewController ()



@end



@implementation IndividualWeightExerciseViewController


@synthesize wExercise, exercisePickerView, weightExercises, weightTableView, cellRepsLabel, cellSetsLabel, cellWeightLabel, weightRepSetCell, datePickerView, weightRepSetsPickerView, isPickerViewShowing, isExercisePickerViewShowing, isWeightRepSetsPickerViewShowing, isDatePickerViewShowing, exerciseNameLabel, dateLabel, US, exercises, fetchRequest, managedObjectContext, selectedRow, standardDefaults;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if (section == 0) {
        if (isPickerViewShowing) {
            return 4;
        } else{
            return 3;
        }
    } else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.row == 1 && isExercisePickerViewShowing) {
        return exercisePickerView.frame.size.height;
    }
    else if (indexPath.row == 2 && isDatePickerViewShowing) {
        return datePickerView.frame.size.height;
    }
    else if (indexPath.row == 3 && isWeightRepSetsPickerViewShowing) {
        return weightRepSetsPickerView.frame.size.height;
    } else{
        return 44;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Tap Rows to Edit";
    } else{
        return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    

    if(indexPath.section == 0){
    
        if (indexPath.row == 0) {

            cell.textLabel.text = @"Name";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = exerciseNameLabel;
            
        }
        else if (indexPath.row == 1) {
            
            if (!isExercisePickerViewShowing) {
                
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.text = @"Date";
                cell.accessoryView = dateLabel;
                
            } else{
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:exercisePickerView];
                [exercisePickerView selectRow:selectedRow inComponent:0 animated:YES];
               
            }

        }
        else if (indexPath.row == 2) {
            
            if (isDatePickerViewShowing) {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:datePickerView];
                [datePickerView setDate:wExercise.date animated:YES];
                
            } else if(isExercisePickerViewShowing && !isWeightRepSetsPickerViewShowing){
                
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textLabel.text = @"Date";
                cell.accessoryView = dateLabel;
               
            } else{
                
                weightRepSetCell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell = weightRepSetCell;
                
            }
        }
        else if (indexPath.row == 3) {
            
            if ((isExercisePickerViewShowing || isDatePickerViewShowing) && !isWeightRepSetsPickerViewShowing) {
                
                weightRepSetCell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell = weightRepSetCell;
                
            } else {
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell addSubview:weightRepSetsPickerView];
                if(US){
                    [weightRepSetsPickerView selectRow:[wExercise.weight integerValue]-1 inComponent:0 animated:YES];
                } else{
                    NSInteger index = [wExercise.weight doubleValue]* 0.453592;
                    [weightRepSetsPickerView selectRow:index inComponent:0 animated:YES];
                }
                [weightRepSetsPickerView selectRow:[wExercise.reps integerValue]-1 inComponent:1 animated:YES];
                [weightRepSetsPickerView selectRow:[wExercise.sets integerValue]-1 inComponent:2 animated:YES];
            }
        }
        
    }else if(indexPath.section == 1){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:cell.frame];
        cellLabel.text = @"Delete";
        cellLabel.textColor = [UIColor redColor];
        cellLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        cellLabel.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:cellLabel];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (isWeightRepSetsPickerViewShowing) {
                isWeightRepSetsPickerViewShowing = NO;
                isPickerViewShowing = NO;
                
                int rowIndex = 3;//your row index where you want to delete cell
                int sectionIndex = 0;//your section index
                NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                NSArray *array = [NSArray arrayWithObject:iPath];
                [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            }
            if (isDatePickerViewShowing) {
                
                isDatePickerViewShowing = NO;
                isPickerViewShowing = NO;
                //cardioExerciseTableView.scrollEnabled = NO; add support later
                int rowIndex = 2;//your row index where you want to delete cell
                int sectionIndex = 0;//your section index
                NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                NSArray *array = [NSArray arrayWithObject:iPath];
                [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            }
            if (!isExercisePickerViewShowing) {
                isExercisePickerViewShowing = YES;
                isPickerViewShowing = YES;
                int rowIndex = 1;//your row index where you want to add cell
                int sectionIndex = 0;//your section index
                NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                NSArray *array = [NSArray arrayWithObject:iPath];
                [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            } else if(isExercisePickerViewShowing){
                isExercisePickerViewShowing = NO;
                isPickerViewShowing = NO;
                int rowIndex = 1;//your row index where you want to add cell
                int sectionIndex = 0;//your section index
                NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                [weightTableView deselectRowAtIndexPath:indexPath animated:YES];
                NSArray *array = [NSArray arrayWithObject:iPath];
                [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        if(indexPath.row == 1){
            if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Date"]){
                
                if (isWeightRepSetsPickerViewShowing) {
                    isWeightRepSetsPickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 3;//your row index where you want to delete cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                if (!isDatePickerViewShowing) {
                    isDatePickerViewShowing = YES;
                    isPickerViewShowing = YES;
                    int rowIndex = 2;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                } else if(isDatePickerViewShowing){
                    isDatePickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 2;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [weightTableView deselectRowAtIndexPath:indexPath animated:YES];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
        }
        if (indexPath.row == 2) {
            if ([[tableView cellForRowAtIndexPath:indexPath] isEqual:weightRepSetCell]){
                if (!isWeightRepSetsPickerViewShowing) {
                    isWeightRepSetsPickerViewShowing = YES;
                    isPickerViewShowing = YES;
                    int rowIndex = 3;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                } else if(isWeightRepSetsPickerViewShowing){
                    isWeightRepSetsPickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 3;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [weightTableView deselectRowAtIndexPath:indexPath animated:YES];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                
            } else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Date"]){
                if(isExercisePickerViewShowing){
                    isExercisePickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 1;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                if (!isDatePickerViewShowing) {
                    isDatePickerViewShowing = YES;
                    isPickerViewShowing = YES;
                    int rowIndex = 2;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                } else if(isDatePickerViewShowing){
                    isDatePickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 2;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [weightTableView deselectRowAtIndexPath:iPath animated:YES];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
        if (indexPath.row == 3) {
            if ([[tableView cellForRowAtIndexPath:indexPath] isEqual:weightRepSetCell]){
                if (isDatePickerViewShowing) {
                    
                    isDatePickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    //cardioExerciseTableView.scrollEnabled = NO; add support later
                    int rowIndex = 2;//your row index where you want to delete cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                if(isExercisePickerViewShowing){
                    isExercisePickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 1;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                if (!isWeightRepSetsPickerViewShowing) {
                    isWeightRepSetsPickerViewShowing = YES;
                    isPickerViewShowing = YES;
                    int rowIndex = 3;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                } else if(isWeightRepSetsPickerViewShowing){
                    isWeightRepSetsPickerViewShowing = NO;
                    isPickerViewShowing = NO;
                    int rowIndex = 3;//your row index where you want to add cell
                    int sectionIndex = 0;//your section index
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [weightTableView deselectRowAtIndexPath:iPath animated:YES];
                    NSArray *array = [NSArray arrayWithObject:iPath];
                    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
            
        }

    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you wish to delete this record?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Record" otherButtonTitles:nil,nil];
        [actionSheet showFromTabBar:self.view];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 1) {
        return indexPath;
    }
    else if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
       
        return nil;
        
    } else{
        
        return indexPath;
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSManagedObject *managedWeight = wExercise;
        [managedObjectContext deleteObject:managedWeight];
        
        NSError *error;
        [managedObjectContext save:&error];

        //cExercise = nil;
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:exercisePickerView]) {
        return 1;
    }else{
        return 3;
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:exercisePickerView]) {
        return [weightExercises count];
    }else{
        if (component == 0) {
            return 501;
        }
        if (component == 1) {
            return 101;
        } else{
            return 26;
        }
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:exercisePickerView]) {
        return [[weightExercises objectAtIndex:row] valueForKey:@"name"];
    } else{
        return [NSString stringWithFormat:@"%ld", (long)row+1];
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if ([pickerView isEqual:exercisePickerView]) {
        
        wExercise.name = [[weightExercises objectAtIndex:row] valueForKey:@"name"];
        exerciseNameLabel.text = [[weightExercises objectAtIndex:row] valueForKey:@"name"];
        selectedRow = row;
        
    } else{
        
        standardDefaults = [NSUserDefaults standardUserDefaults];
        
        if ([[standardDefaults objectForKey:@"Units"] isEqualToString:@"US"]) {
            
            wExercise.weight = [NSNumber numberWithInteger:[weightRepSetsPickerView selectedRowInComponent:0]+1];
            cellWeightLabel.text = [NSString stringWithFormat:@"%.0ld lb", (long)[weightRepSetsPickerView selectedRowInComponent:0]+1];
            
        } else{
            
            wExercise.weight = [NSNumber numberWithInteger:([weightRepSetsPickerView selectedRowInComponent:0]+1) * 2.20462];
            
            cellWeightLabel.text = [NSString stringWithFormat:@"%.0f kg", ([wExercise.weight doubleValue]+1) * 0.453592];
        }
        
        cellRepsLabel.text = [NSString stringWithFormat:@"%ld", (long)[weightRepSetsPickerView selectedRowInComponent:1]+1];
        wExercise.reps = [NSNumber numberWithInteger:[weightRepSetsPickerView selectedRowInComponent:1]+1];
        
        cellSetsLabel.text = [NSString stringWithFormat:@"%ld", (long)[weightRepSetsPickerView selectedRowInComponent:2]+1];
        wExercise.sets  = [NSNumber numberWithInteger:[weightRepSetsPickerView selectedRowInComponent:2]+1];

    }
}

- (void) dateChanged:(id)sender {
    wExercise.date = datePickerView.date;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *dateSelected =[formatter stringFromDate:wExercise.date];
    dateLabel.text = dateSelected;
}



@end
