//
//  KTLCallenderViewController.m
//  
//
//  Created by Bob Law
//  
//

#import "VRGViewController.h"
#import "NSDate+convenience.h"
#import "Plan_Exercise.h"
#import "PlanExercisesViewController.h"
#import "SVProgressHUD.h"



@interface VRGViewController ()


@end

@implementation VRGViewController

@synthesize workoutTableView, selectedDate, todaysExercises, exercises, rightBarButton, leftBarItem, calendar, fetchRequest, managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
      
    calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    [self.view sendSubviewToBack:calendar];
    
    
    self.rightBarButton.enabled = NO;
   
    todaysExercises = [NSMutableArray array];
    [self.workoutTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
}

-(void) viewDidAppear:(BOOL)animated{
    
    [self.workoutTableView reloadData];
  //  [self.workoutTableView reloadInputViews];
}




- (IBAction)tableViewButtonPressed:(id)sender {
    
    leftBarItem.selected = !leftBarItem.isSelected;
    
    if (leftBarItem.selected) {
        
        

        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           [self.leftBarItem setTransform:CGAffineTransformRotate(self.leftBarItem.transform, M_PI)];
        } completion:nil];
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame;
            
            frame=workoutTableView.frame;
            frame.origin.y=calendar.frame.origin.y;
            frame.size.height = self.view.frame.size.height - 30 - 35;
            workoutTableView.frame=frame;
            
            frame=calendar.frame;
            frame.origin.y= 65 - calendar.frame.size.height;
            calendar.frame=frame;
            
            
        }];
    } else {
        
        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.leftBarItem setTransform:CGAffineTransformRotate(self.leftBarItem.transform, -M_PI)];
        } completion:nil];
      
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame;
            
            frame=calendar.frame;
            frame.origin.y=65;
            calendar.frame=frame;
            
            frame=workoutTableView.frame;
            frame.origin.y=calendar.frame.size.height + 65;
            frame.size.height = self.view.frame.size.height - 65 - calendar.frame.size.height;
            workoutTableView.frame=frame;

        }];

    }
}

- (NSArray *) markDates{

    NSMutableArray *datesToBeMarked = [[NSMutableArray alloc] init];
    for (Plan_Exercise *planExercise in exercises) {
        if ([planExercise.date month] == [[calendar currentMonth] month] && [planExercise.date year] == [[calendar currentMonth] year]) {
            [datesToBeMarked addObject:[NSNumber numberWithInteger:[planExercise.date day]]];
        }
    }
    
    
    return [NSArray arrayWithArray:datesToBeMarked];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    self.rightBarButton.enabled = NO;
    selectedDate = nil;
    [self findTodaysExercises];
    [self.workoutTableView reloadData];
    [calendar markDates:[self markDates]];
    
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect frame;

        frame=workoutTableView.frame;
        frame.origin.y=targetHeight + 65;
        frame.size.height = self.view.frame.size.height - 65 - targetHeight;
        workoutTableView.frame=frame;
        
    }];
    
   }

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    selectedDate = date;
    self.rightBarButton.enabled = YES;
    
    [self findTodaysExercises];
    [self.workoutTableView reloadData];

}


//Table View Stuff Here

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return [todaysExercises count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[todaysExercises objectAtIndex:indexPath.row] valueForKey:@"name"];
   

    if([[[todaysExercises objectAtIndex:indexPath.row] valueForKey:@"isCompleted"] isEqualToNumber:[NSNumber numberWithBool:YES]]){
        
        cell.accessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"smallBlueCheckmark.png"]];
       
    } else {
        
        cell.accessoryView = nil;
    }
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        [self.managedObjectContext deleteObject:[todaysExercises objectAtIndex:indexPath.row]];
        [todaysExercises removeObjectAtIndex:indexPath.row];
        NSError *error = nil;
        // Save the object to persistent store
        [managedObjectContext save:&error];
        
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [calendar markDates:[self markDates]];

        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void) findTodaysExercises{
    
    [todaysExercises removeAllObjects];
    
    managedObjectContext = [self managedObjectContext];
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Plan_Exercise"];
    NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:srt]];
    exercises = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
   
    for(Plan_Exercise *planExercise in exercises){

        if(([planExercise.date day] == [selectedDate day]) && ([planExercise.date month] == [selectedDate month]) && ([planExercise.date year] == [selectedDate year])){
            
            [todaysExercises addObject:planExercise];
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"addplan"]){
        
        PlanExercisesViewController *planExercisesViewController = segue.destinationViewController;
        planExercisesViewController.delegate = self;
        planExercisesViewController.selectedDate = selectedDate;
        
    }
}



-(void)planExercisesViewController:(PlanExercisesViewController *)controller viewDidDismiss:(NSMutableArray *) names{
   
    BOOL didAddExerciseToPlan = NO;
    if ([todaysExercises count] > 0) {
        NSMutableArray *namesOfAlreadyPlannedExercises = [NSMutableArray array];
        for (Plan_Exercise *planExercise in todaysExercises){
            [namesOfAlreadyPlannedExercises addObject:planExercise.name];
        }
        for (NSString *name in names) {
            
            if([namesOfAlreadyPlannedExercises indexOfObject:name] == NSNotFound){
                
                NSManagedObject *newExercise = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Exercise" inManagedObjectContext:managedObjectContext];
                [newExercise setValue:name forKey:@"name"];
                [newExercise setValue:selectedDate forKey:@"date"];
                [newExercise setValue:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
                //   [managedObjectContext insertObject:newExercise];
                
                NSError *error = nil;
                // Save the object to persistent store
                [managedObjectContext save:&error];
                
                [exercises addObject:newExercise];
                didAddExerciseToPlan = YES;
                
                
            }
            
        }
    } else{
        for (NSString *name in names) {
            
            NSManagedObject *newExercise = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Exercise" inManagedObjectContext:managedObjectContext];
            [newExercise setValue:name forKey:@"name"];
            [newExercise setValue:selectedDate forKey:@"date"];
            [newExercise setValue:[NSNumber numberWithBool:NO] forKey:@"isCompleted"];
           // [exercises addObject:newExercise];
            
            NSError *error = nil;
            // Save the object to persistent store
            [managedObjectContext save:&error];
            
            [exercises addObject:newExercise];
            didAddExerciseToPlan = YES;
        }
    }
 
    if(didAddExerciseToPlan){
        [SVProgressHUD showSuccessWithStatus:@"Saved!"];
    } else{
        [SVProgressHUD showErrorWithStatus:@"Exercises Already Planned!"];
    }
    
    [calendar markDates:[self markDates]];
    [self findTodaysExercises];
    [self.workoutTableView reloadData];
}

@end
