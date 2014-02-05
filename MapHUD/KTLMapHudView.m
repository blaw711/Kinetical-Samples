//
//  KTLMapHudView.m
//  Kinetical
//
//  Created by Bob Law on 1/15/14.
//  Copyright (c) 2014 Bob Law Productions. All rights reserved.
//

#import "KTLMapHudView.h"


@implementation KTLMapHudView

@synthesize timerLabel, speedButton, goalButton, paceButton, directionButton, buttonSelected, averageSpeedLabel, distanceLabel, speedLabel, changeCurrentDisplayButton, weatherButton, daylightButton, caloriesButton, elevationButton, averagePaceLabel, paceLabel, goalPercentageLabel, goalRemainingLabel, directionLabel, elevationLabel, netElevationLabel, weatherLabel, detailWeatherLabel, temperature, weatherSummary, sunriseTimeString, sunsetTimeString, sunriseLabel, sunsetLabel, timerDistanceButton, maxSpeedLabel, fastestPaceLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8f;
        self.layer.borderWidth = 1.5f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 50)];
        [timerLabel setBackgroundColor:[UIColor whiteColor]];
        timerLabel.text = @"00:00";
        timerLabel.textAlignment = UITextAlignmentCenter;
        [timerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:43.0f]];
        timerLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:timerLabel];
        
        distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 160, 50)];
        [distanceLabel setBackgroundColor:[UIColor whiteColor]];
        [distanceLabel setText:@"0.00"];
        [distanceLabel setTextAlignment:UITextAlignmentCenter];
        [distanceLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:42.0f]];
        distanceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:distanceLabel];
        
        
       
        
// Set-up Map HUD Buttons
//----------------------------------------------------------------------------------

        speedButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [speedButton setFrame:CGRectMake(160, 0, 160, 50)];
        [speedButton setTag:1];
        speedButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [speedButton setTitle:@"Speed" forState:UIControlStateNormal];
        [speedButton addTarget:self
                        action:@selector(mapHudButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:speedButton];
        
        paceButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [paceButton setFrame:CGRectMake(160, 50, 160, 50)];
        [paceButton setTag:2];
        paceButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [paceButton setTitle:@"Pace" forState:UIControlStateNormal];
        [paceButton addTarget:self
                       action:@selector(mapHudButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:paceButton];
        
        goalButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [goalButton setFrame:CGRectMake(320, 0, 160, 50)];
        [goalButton setTag:3];
        goalButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [goalButton setTitle:@"Goal" forState:UIControlStateNormal];
        [goalButton addTarget:self
                        action:@selector(mapHudButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goalButton];
        
        directionButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [directionButton setFrame:CGRectMake(320, 50, 160, 50)];
        [directionButton setTag:4];
        directionButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [directionButton setTitle:@"Compass" forState:UIControlStateNormal];
        [directionButton addTarget:self
                       action:@selector(mapHudButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:directionButton];
        
        
        caloriesButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [caloriesButton setFrame:CGRectMake(320, 0, 160, 50)];
        [caloriesButton setTag:7];
        caloriesButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [caloriesButton setTitle:@"Highs" forState:UIControlStateNormal];
        [caloriesButton addTarget:self
                          action:@selector(mapHudButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:caloriesButton];
        
        elevationButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [elevationButton setFrame:CGRectMake(320, 50, 160, 50)];
        [elevationButton setTag:8];
        elevationButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [elevationButton setTitle:@"Elevation" forState:UIControlStateNormal];
        [elevationButton addTarget:self
                           action:@selector(mapHudButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:elevationButton];
        
        weatherButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [weatherButton setFrame:CGRectMake(320, 0, 160, 50)];
        [weatherButton setTag:5];
        weatherButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [weatherButton setTitle:@"Weather" forState:UIControlStateNormal];
        [weatherButton addTarget:self
                          action:@selector(mapHudButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weatherButton];
        
        daylightButton = [KTLMapHudButton buttonWithType:UIButtonTypeRoundedRect];
        [daylightButton setFrame:CGRectMake(320, 50, 160, 50)];
        [daylightButton setTag:6];
        daylightButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:23.0f];
        [daylightButton setTitle:@"Daylight" forState:UIControlStateNormal];
        [daylightButton addTarget:self
                           action:@selector(mapHudButtonPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:daylightButton];
        
        changeCurrentDisplayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [changeCurrentDisplayButton setFrame:CGRectMake(145, 35, 30, 30)];
        [changeCurrentDisplayButton setTag:1];
        [changeCurrentDisplayButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20.0f]];
        changeCurrentDisplayButton.layer.cornerRadius = 15.0;
        changeCurrentDisplayButton.layer.borderWidth = 1.5f;
        changeCurrentDisplayButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        changeCurrentDisplayButton.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:97.0/255.0 blue:155.0/255.0 alpha:1.0];
        [changeCurrentDisplayButton setTitle:@"1" forState:UIControlStateNormal];
        [changeCurrentDisplayButton addTarget:self
                                       action:@selector(changeCurrentDisplayButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeCurrentDisplayButton];
        [self bringSubviewToFront:changeCurrentDisplayButton];
        
        timerDistanceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [timerDistanceButton setFrame:CGRectMake(0, 0, 160, 100)];
        [timerDistanceButton addTarget:self
    action:@selector(changeCurrentDisplayButtonPressed:)
    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:timerDistanceButton];
        [self bringSubviewToFront:timerDistanceButton];
//----------------------------------------------------------------------------------
        
        speedLabel = [[UILabel alloc] init];
        [speedLabel setFrame:CGRectMake(160, 0, 160, 50)];
        speedLabel.alpha = 0;
        speedLabel.textAlignment = UITextAlignmentCenter;
        speedLabel.text = @"N/A";
        speedLabel.numberOfLines = 2;
        [speedLabel setLineBreakMode:UILineBreakModeWordWrap];
        speedLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        speedLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:speedLabel];
        
        averageSpeedLabel = [[UILabel alloc] init];
        [averageSpeedLabel setFrame:CGRectMake(160, 0, 160, 50)];
        averageSpeedLabel.alpha = 0;
        averageSpeedLabel.textAlignment = UITextAlignmentCenter;
        averageSpeedLabel.text = @"N/A";
        averageSpeedLabel.numberOfLines = 2;
        [averageSpeedLabel setLineBreakMode:UILineBreakModeWordWrap];
        averageSpeedLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        averageSpeedLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:averageSpeedLabel];
        
        
        paceLabel = [[UILabel alloc] init];
        [paceLabel setFrame:CGRectMake(160, 50, 160, 50)];
        paceLabel.alpha = 0;
        paceLabel.textAlignment = UITextAlignmentCenter;
        paceLabel.text = @"N/A";
        [paceLabel setLineBreakMode:UILineBreakModeWordWrap];
        paceLabel.numberOfLines = 2;
        paceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        paceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:paceLabel];
        
        averagePaceLabel = [[UILabel alloc] init];
        [averagePaceLabel setFrame:CGRectMake(160, 50, 160, 50)];
        averagePaceLabel.alpha = 0;
        averagePaceLabel.textAlignment = UITextAlignmentCenter;
        averagePaceLabel.text = @"N/A";
        averagePaceLabel.numberOfLines = 2;
        [averagePaceLabel setLineBreakMode:UILineBreakModeWordWrap];
        averagePaceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        averagePaceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:averagePaceLabel];
        
        maxSpeedLabel = [[UILabel alloc] init];
        [maxSpeedLabel setFrame:CGRectMake(160, 0, 160, 50)];
        maxSpeedLabel.alpha = 0;
        maxSpeedLabel.textAlignment = UITextAlignmentCenter;
        maxSpeedLabel.text = @"N/A";
        maxSpeedLabel.numberOfLines = 2;
        [maxSpeedLabel setLineBreakMode:UILineBreakModeWordWrap];
        maxSpeedLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        maxSpeedLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:maxSpeedLabel];
        
        fastestPaceLabel = [[UILabel alloc] init];
        [fastestPaceLabel setFrame:CGRectMake(160, 0, 160, 50)];
        fastestPaceLabel.alpha = 0;
        fastestPaceLabel.textAlignment = UITextAlignmentCenter;
        fastestPaceLabel.text = @"N/A";
        fastestPaceLabel.numberOfLines = 2;
        [fastestPaceLabel setLineBreakMode:UILineBreakModeWordWrap];
        fastestPaceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:34.0f];
        fastestPaceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:fastestPaceLabel];

        
        goalPercentageLabel = [[UILabel alloc] init];
        [goalPercentageLabel setFrame:CGRectMake(160, 0, 160, 50)];
        goalPercentageLabel.alpha = 0;
        goalPercentageLabel.textAlignment = UITextAlignmentCenter;
        goalPercentageLabel.text = @"No goals for";
        [goalPercentageLabel setLineBreakMode:UILineBreakModeWordWrap];
        goalPercentageLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:22.0f];
        goalPercentageLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:goalPercentageLabel];
        
        goalRemainingLabel = [[UILabel alloc] init];
        [goalRemainingLabel setFrame:CGRectMake(160, 0, 160, 50)];
        goalRemainingLabel.alpha = 0;
        goalRemainingLabel.textAlignment = UITextAlignmentCenter;
        goalRemainingLabel.text = @"this exercise.";
        [goalRemainingLabel setLineBreakMode:UILineBreakModeWordWrap];
        goalRemainingLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:22.0f];
        goalRemainingLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:goalRemainingLabel];
        
        directionLabel = [[UILabel alloc] init];
        [directionLabel setFrame:CGRectMake(160, 50, 160, 50)];
        directionLabel.alpha = 0;
        directionLabel.textAlignment = UITextAlignmentCenter;
        //directionLabel.text = @"Goal %";
        [directionLabel setLineBreakMode:UILineBreakModeWordWrap];
        directionLabel.numberOfLines = 2;
        directionLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:directionLabel];
        
        
        elevationLabel = [[UILabel alloc] init];
        [elevationLabel setFrame:CGRectMake(160, 50, 160, 50)];
        elevationLabel.alpha = 0;
        elevationLabel.textAlignment = UITextAlignmentCenter;
        elevationLabel.text = @"N/A";
        elevationLabel.numberOfLines = 2;
        [elevationLabel setLineBreakMode:UILineBreakModeWordWrap];
        elevationLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35.0f];
        elevationLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:elevationLabel];
        
        netElevationLabel = [[UILabel alloc] init];
        [netElevationLabel setFrame:CGRectMake(160, 50, 160, 50)];
        netElevationLabel.alpha = 0;
        netElevationLabel.textAlignment = UITextAlignmentCenter;
        netElevationLabel.text = @"N/A";
        netElevationLabel.numberOfLines = 2;
        [netElevationLabel setLineBreakMode:UILineBreakModeWordWrap];
        netElevationLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35.0f];
        netElevationLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:netElevationLabel];
        
        weatherLabel = [[UILabel alloc] init];
        [weatherLabel setFrame:CGRectMake(160, 0, 160, 50)];
        weatherLabel.alpha = 0;
        weatherLabel.textAlignment = UITextAlignmentCenter;
        weatherLabel.text = @"N/A";
        //weatherLabel.numberOfLines = 2;
        [weatherLabel setLineBreakMode:UILineBreakModeWordWrap];
        weatherLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35.0f];
        //weatherLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:weatherLabel];
        
        detailWeatherLabel = [[UILabel alloc] init];
        [detailWeatherLabel setFrame:CGRectMake(160, 0, 160, 50)];
        detailWeatherLabel.alpha = 0;
        detailWeatherLabel.textAlignment = UITextAlignmentCenter;
        detailWeatherLabel.text = @"N/A";
        detailWeatherLabel.numberOfLines = 2;
        //[detailWeatherLabel setLineBreakMode:UILineBreakModeWordWrap];
        detailWeatherLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:30.0f];
        detailWeatherLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:detailWeatherLabel];

        sunriseLabel = [[UILabel alloc] init];
        [sunriseLabel setFrame:CGRectMake(160, 50, 160, 50)];
        sunriseLabel.alpha = 0;
        sunriseLabel.textAlignment = UITextAlignmentCenter;
        sunriseLabel.text = @"N/A";
        sunriseLabel.numberOfLines = 2;
        [sunriseLabel setLineBreakMode:UILineBreakModeWordWrap];
        sunriseLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35.0f];
        sunriseLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:sunriseLabel];
        
        sunsetLabel = [[UILabel alloc] init];
        [sunsetLabel setFrame:CGRectMake(160, 50, 160, 50)];
        sunsetLabel.alpha = 0;
        sunsetLabel.textAlignment = UITextAlignmentCenter;
        sunsetLabel.text = @"N/A";
        sunsetLabel.numberOfLines = 2;
        [sunsetLabel setLineBreakMode:UILineBreakModeWordWrap];
        sunsetLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35.0f];
        sunsetLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:sunsetLabel];
        
        
        

       // [self bringSubviewToFront:speedButton];
    }
    return self;
}

- (IBAction)mapHudButtonPressed:(id) sender {
    
    
    
    //self.buttonTag = [sender tag];
    
    if (!buttonSelected) {
        
        [self bringSubviewToFront:sender];
        

        buttonSelected = YES;

        
        [UIView animateWithDuration:0.3f animations:^{
            
            changeCurrentDisplayButton.alpha = 0;
            timerDistanceButton.alpha = 0;
            
            //[sender setTintColor:[UIColor whiteColor]];
            [sender setBackgroundColor:[UIColor whiteColor]];
            
            CGRect frame;
            
            if ([sender tag] == 1){
                
                frame = speedButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                speedButton.frame = frame;
                [speedButton setTitle:Nil forState:UIControlStateNormal];
                
                averageSpeedLabel.frame = CGRectMake(160, 50, 160, 50);
                averageSpeedLabel.alpha = 1;
                [self bringSubviewToFront:averageSpeedLabel];
                
                speedLabel.frame = CGRectMake(160, 0, 160, 50);
                speedLabel.alpha = 1;
                [self bringSubviewToFront:speedLabel];
                
            } else if([sender tag] == 2){
                
                frame = paceButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                paceButton.frame = frame;
                [paceButton setTitle:Nil forState:UIControlStateNormal];

                
                paceLabel.frame = CGRectMake(160, 0, 160, 50);
                paceLabel.alpha = 1;
                [self bringSubviewToFront:paceLabel];

                averagePaceLabel.frame = CGRectMake(160, 50, 160, 50);
                averagePaceLabel.alpha = 1;
                [self bringSubviewToFront:averagePaceLabel];
                
                                
            }else if([sender tag] == 3){
                
                frame = goalButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                goalButton.frame = frame;
                [goalButton setTitle:Nil forState:UIControlStateNormal];
                
                goalPercentageLabel.frame = CGRectMake(160, 0, 160, 50);
                goalPercentageLabel.alpha = 1;
                [self bringSubviewToFront:goalPercentageLabel];
                
                goalRemainingLabel.frame = CGRectMake(160, 50, 160, 50);
                goalRemainingLabel.alpha = 1;
                [self bringSubviewToFront:goalRemainingLabel];
                
            } else if([sender tag] == 4){
                
                frame = directionButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                directionButton.frame = frame;
                [directionButton setTitle:Nil forState:UIControlStateNormal];

                frame = directionLabel.frame;
                frame = CGRectMake(160, 5, 160, 100);
                directionLabel.frame = frame;
                directionLabel.alpha = 1;
                [self bringSubviewToFront:directionLabel];
                
            }else if([sender tag] == 5){
                
                frame = weatherButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                weatherButton.frame = frame;
                [weatherButton setTitle:Nil forState:UIControlStateNormal];

                
                weatherLabel.frame = CGRectMake(160, 0, 160, 50);
                weatherLabel.alpha = 1;
                [self bringSubviewToFront:weatherLabel];
                
                detailWeatherLabel.frame = CGRectMake(160, 50, 160, 50);
                detailWeatherLabel.alpha = 1;
                [self bringSubviewToFront:detailWeatherLabel];
                
            }else if([sender tag] == 6){
                
                frame = daylightButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                daylightButton.frame = frame;
                [daylightButton setTitle:Nil forState:UIControlStateNormal];
                
                sunriseLabel.frame = CGRectMake(160, 0, 160, 50);
                sunriseLabel.alpha = 1;
                [self bringSubviewToFront:sunriseLabel];
                
                sunsetLabel.frame = CGRectMake(160, 50, 160, 50);
                sunsetLabel.alpha = 1;
                [self bringSubviewToFront:sunsetLabel];
                
            }else if([sender tag] == 7){
                
                frame = caloriesButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                caloriesButton.frame = frame;
                
                maxSpeedLabel.frame = CGRectMake(160, 0, 160, 50);
                maxSpeedLabel.alpha = 1;
                [self bringSubviewToFront:maxSpeedLabel];
                
                fastestPaceLabel.frame = CGRectMake(160, 50, 160, 50);
                fastestPaceLabel.alpha = 1;
                [self bringSubviewToFront:fastestPaceLabel];
                
            }else if([sender tag] == 8){
                
                frame = elevationButton.frame;
                frame = CGRectMake(160, 0, 160, 100);
                elevationButton.frame = frame;
                [elevationButton setTitle:Nil forState:UIControlStateNormal];

                elevationLabel.frame = CGRectMake(160, 0, 160, 50);
                elevationLabel.alpha = 1;
                [self bringSubviewToFront:elevationLabel];
                
                netElevationLabel.frame = CGRectMake(160, 50, 160, 50);
                netElevationLabel.alpha = 1;
                [self bringSubviewToFront:netElevationLabel];
            }
            
        }];
      
    }else{
        
        buttonSelected = NO;
        
        speedButton.selected = NO;
        directionLabel.alpha = 0;
        [UIView animateWithDuration:0.1f animations:^{

        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            changeCurrentDisplayButton.alpha = 1;
            timerDistanceButton.alpha = 1;
            
            [sender setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:97.0/255.0 blue:155.0/255.0 alpha:1.0]];

            
            CGRect frame;
            
            if ([sender tag] == 1){
                
                [speedButton setTitle:@"Speed" forState:UIControlStateNormal];
                
                frame = speedButton.frame;
                frame = CGRectMake(160, 0, 160, 50);
                speedButton.frame = frame;
                
                frame = speedLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                speedLabel.frame = frame;
                speedLabel.alpha = 0;
                
                frame = averageSpeedLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                averageSpeedLabel.frame = frame;
                averageSpeedLabel.alpha = 0;
                
            } else if([sender tag] == 2){
                
                frame = paceButton.frame;
                frame = CGRectMake(160, 50, 160, 50);
                paceButton.frame = frame;
                [paceButton setTitle:@"Pace" forState:UIControlStateNormal];
                
                
                paceLabel.frame = CGRectMake(160, 50, 160, 50);
                paceLabel.alpha = 0;
                
                averagePaceLabel.frame = CGRectMake(160, 50, 160, 50);
                averagePaceLabel.alpha = 0;
                
                
            }else if([sender tag] == 3){
                
                frame = goalButton.frame;
                frame = CGRectMake(160, 0, 160, 50);
                goalButton.frame = frame;
                [goalButton setTitle:@"Goal" forState:UIControlStateNormal];
                
                
                frame = goalPercentageLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                goalPercentageLabel.frame = frame;
                goalPercentageLabel.alpha = 0;
                
                frame = goalRemainingLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                goalRemainingLabel.frame = frame;
                goalRemainingLabel.alpha = 0;
                
            } else if ([sender tag] == 4){
                
                frame = directionButton.frame;
                frame = CGRectMake(160, 50, 160, 50);
                directionButton.frame = frame;
                [directionButton setTitle:@"Compass" forState:UIControlStateNormal];

                frame = directionLabel.frame;
                frame = CGRectMake(160, 50, 160, 50);
                directionLabel.frame = frame;
                directionLabel.alpha = 0;
                
            } else if ([sender tag] == 5){
                
                frame = weatherButton.frame;
                frame = CGRectMake(160, 0, 160, 50);
                weatherButton.frame = frame;
                [weatherButton setTitle:@"Weather" forState:UIControlStateNormal];

                
                frame = weatherLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                weatherLabel.frame = frame;
                weatherLabel.alpha = 0;
                
                frame = detailWeatherLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                detailWeatherLabel.frame = frame;
                detailWeatherLabel.alpha = 0;
  
                
            } else if([sender tag] == 6){
                
                frame = daylightButton.frame;
                frame = CGRectMake(160, 50, 160, 50);
                daylightButton.frame = frame;
                [daylightButton setTitle:@"Daylight" forState:UIControlStateNormal];
                
                frame = sunriseLabel.frame;
                frame = CGRectMake(160, 50, 160, 50);
                sunriseLabel.frame = frame;
                sunriseLabel.alpha = 0;
                
                frame = sunsetLabel.frame;
                frame = CGRectMake(160, 50, 160, 50);
                sunsetLabel.frame = frame;
                sunsetLabel.alpha = 0;

                
            }else if([sender tag] == 7){
                
                frame = caloriesButton.frame;
                frame = CGRectMake(160, 0, 160, 50);
                caloriesButton.frame = frame;
                [caloriesButton setTitle:@"Highs" forState:UIControlStateNormal];

                frame = maxSpeedLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                maxSpeedLabel.frame = frame;
                maxSpeedLabel.alpha = 0;
                
                frame = fastestPaceLabel.frame;
                frame = CGRectMake(160, 0, 160, 50);
                fastestPaceLabel.frame = frame;
                fastestPaceLabel.alpha = 0;
                
            } else if ([sender tag] == 8){
                
                frame = elevationButton.frame;
                frame = CGRectMake(160, 50, 160, 50);
                elevationButton.frame = frame;
                [elevationButton setTitle:@"Elevation" forState:UIControlStateNormal];

                frame = elevationLabel.frame;
                frame = CGRectMake(160, 50, 160, 50);
                elevationLabel.frame = frame;
                elevationLabel.alpha = 0;
                
                frame = netElevationLabel.frame;
                frame = CGRectMake(160, 50, 160, 50);
                netElevationLabel.frame = frame;
                netElevationLabel.alpha = 0;
                
            }

            
        }];
        //[self bringSubviewToFront:changeCurrentDisplayButton];
    }
    
[self bringSubviewToFront:changeCurrentDisplayButton];
    
    
}

- (IBAction)changeCurrentDisplayButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.35f animations:^{
        
        CGRect frame;
        
        if(changeCurrentDisplayButton.tag == 1){
            
            frame = weatherButton.frame;
            frame.origin.x = self.frame.size.width;
            weatherButton.frame = frame;
            
            
            frame = daylightButton.frame;
            frame.origin.x = self.frame.size.width;
            daylightButton.frame = frame;
            
            
            speedButton.alpha = 0;
            paceButton.alpha = 0;
            
            
            frame = goalButton.frame;
            frame.origin.x = 160;;
            goalButton.frame = frame;
            goalButton.alpha = 1;
            
            frame = directionButton.frame;
            frame.origin.x = 160;
            directionButton.frame = frame;
            directionButton.alpha = 1;
            
        }else if(changeCurrentDisplayButton.tag == 2){
            
            frame = speedButton.frame;
            frame.origin.x = self.frame.size.width;
            speedButton.frame = frame;
                        
            frame = paceButton.frame;
            frame.origin.x = self.frame.size.width;
            paceButton.frame = frame;
            
            goalButton.alpha = 0;
            directionButton.alpha = 0;
            
            
            frame = caloriesButton.frame;
            frame.origin.x = 160;;
            caloriesButton.frame = frame;
            caloriesButton.alpha = 1;
            
            frame = elevationButton.frame;
            frame.origin.x = 160;
            elevationButton.frame = frame;
            elevationButton.alpha = 1;
            
        }else if(changeCurrentDisplayButton.tag == 3){
            
            frame = goalButton.frame;
            frame.origin.x = self.frame.size.width;
            goalButton.frame = frame;
            
            
            frame = directionButton.frame;
            frame.origin.x = self.frame.size.width;
            directionButton.frame = frame;
            
            
            caloriesButton.alpha = 0;
            elevationButton.alpha = 0;
            
            
            frame = weatherButton.frame;
            frame.origin.x = 160;;
            weatherButton.frame = frame;
            weatherButton.alpha = 1;
            
            frame = daylightButton.frame;
            frame.origin.x = 160;
            daylightButton.frame = frame;
            daylightButton.alpha = 1;
        }else{
            
            frame = caloriesButton.frame;
            frame.origin.x = self.frame.size.width;
            caloriesButton.frame = frame;
            
            
            frame = elevationButton.frame;
            frame.origin.x = self.frame.size.width;
            elevationButton.frame = frame;
            
            
            weatherButton.alpha = 0;
            daylightButton.alpha = 0;
            
            frame = speedButton.frame;
            frame.origin.x = 160;;
            speedButton.frame = frame;
            speedButton.alpha = 1;
           
            frame = paceButton.frame;
            frame.origin.x = 160;
            paceButton.frame = frame;
            paceButton.alpha = 1;
            
        }
    }];
    
    if (changeCurrentDisplayButton.tag == 4) {
            
            changeCurrentDisplayButton.tag = 1;
            
        } else{
            
            changeCurrentDisplayButton.tag++;
            
        }
        
        [changeCurrentDisplayButton setTitle:[NSString stringWithFormat:@"%ld", (long)changeCurrentDisplayButton.tag] forState:UIControlStateNormal];
    
    [self bringSubviewToFront:changeCurrentDisplayButton];

}

-(void)setTimer:(NSString *)timerString{
    
    timerLabel.text = timerString;
    
}

-(void)setDistance:(NSString *)distanceString{
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:distanceString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial" size:25]
                      range: NSMakeRange([distanceString length]-3,3)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:43]
                      range: NSMakeRange(0,[distanceString length]-3)];
    
    
    distanceLabel.attributedText = attString;
    
}

-(void)setSpeed:(NSString *)speed{
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"Current Speed\n%@", speed]];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0,14)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:20]
                      range: NSMakeRange([[NSString stringWithFormat:@"Current Speed\n%@", speed] length]-4,4)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(14,[[NSString stringWithFormat:@"Current Speed\n%@", speed] length]-19)];
    
    
    speedLabel.attributedText = attString;
    
   
    
}

-(void)setAverageSpeed:(NSString *)avgSpeed{
    
    NSString *avgSpeedString = [NSString stringWithFormat:@"Average Speed\n%@",avgSpeed];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:avgSpeedString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0,14)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:20]
                      range: NSMakeRange([avgSpeedString length]-4,4)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(14,[avgSpeedString length]-18)];
    
    
    averageSpeedLabel.attributedText = attString;
}

- (void)setPace:(NSString *)pace{
    
    NSString *currentPace = [NSString stringWithFormat:@"Current Pace\n%@", pace];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:currentPace];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0, 13)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:20]
                      range: NSMakeRange([currentPace length]-7,7)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(13,[currentPace length]-20)];
    
    
    paceLabel.attributedText = attString;
    
    
    
}

- (void)setAveragePace:(NSString *)avgPace{
    
    NSString *averagePace = [NSString stringWithFormat:@"Average Pace\n%@", avgPace];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:averagePace];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0, 13)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:20]
                      range: NSMakeRange([averagePace length]-7,7)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(13,[averagePace length]-20)];
    
    
    averagePaceLabel.attributedText = attString;
    
    
    
}

- (void)setMaxSpeed:(NSString *)maxSpeed{
    
    NSString *maxSpeedString = [NSString stringWithFormat:@"Max Speed\n%@", maxSpeed];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:maxSpeedString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0,10)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:20]
                      range: NSMakeRange([maxSpeedString length]-4,4)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(10,[maxSpeedString length]-14)];
    
    
    maxSpeedLabel.attributedText = attString;

    
}

- (void)setFastestPace:(NSString *)fastestPace{
    
    NSString *fastestPaceString = [NSString stringWithFormat:@"Fastest Mile Time\n%@", fastestPace];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:fastestPaceString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Helvetica" size:10]
                      range: NSMakeRange(0, 18)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                      range: NSMakeRange(18,[fastestPaceString length]-18)];
    
    
    fastestPaceLabel.attributedText = attString;
    
}

- (void)setGoalPercentage:(double) percentage{
    
    goalPercentageLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:45];
    goalPercentageLabel.text = [NSString stringWithFormat:@"%.0f%%", percentage*100];
    
}
- (void)setGoalRemaining:(double)remainder withString:(NSString *) units{
    
    if (remainder == 0) {
        goalRemainingLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        goalRemainingLabel.text = @"Goal Complete!";
        goalPercentageLabel.textColor = [UIColor greenColor];
        
    } else{
        
        goalPercentageLabel.textColor = [UIColor blackColor];
        
        NSString *remainingGoal = [NSString stringWithFormat:@"%.2f %@ to go", remainder, units];
        
        NSMutableAttributedString *attString =
        [[NSMutableAttributedString alloc]
         initWithString:remainingGoal];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:17]
                          range: NSMakeRange([remainingGoal length]-9,9)];
        
        NSInteger space = [remainingGoal rangeOfString:@" "].location;
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:38]
                          range: NSMakeRange(0,space)];
        
        
        goalRemainingLabel.attributedText = attString;
    }
    
}
- (void)setDirection:(NSString *)direction{
    
    NSString *totDirectionString = [NSString stringWithFormat:@"You are heading\n%@", direction];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:totDirectionString];
    
    if ([totDirectionString length] == 17) {
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:13]
                          range: NSMakeRange(0,15)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:75]
                          range: NSMakeRange(16,1)];
    } else{
        
        
       
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:13]
                          range: NSMakeRange(0,15)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:75]
                          range: NSMakeRange(16,2)];
    }
    
    
    
    directionLabel.attributedText = attString;
    
}
- (void)setElevation:(NSString *) elevation withUnit:(NSString *)unit{
    
    NSString *currentElevation = [NSString stringWithFormat:@"Current Elevation\n%@ %@", elevation, unit];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:currentElevation];
    
    if ([unit isEqualToString:@"ft"]) {
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:10]
                          range: NSMakeRange(0,18)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:20]
                          range: NSMakeRange([currentElevation length]-3,3)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                          range: NSMakeRange(18,[currentElevation length]-20)];
    } else{
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:10]
                          range: NSMakeRange(0,18)];
    
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:20]
                          range: NSMakeRange([currentElevation length]-2,2)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                          range: NSMakeRange(18,[currentElevation length]-20)];
        
    }
    
    elevationLabel.attributedText = attString;
}
- (void)setNetElevation:(double) elevation withUnit:(NSString *) unit{
    
    NSString *currentElevation = [NSString stringWithFormat:@"Net Elevation\n%.2f %@", elevation, unit];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:currentElevation];
    
    if ([unit isEqualToString:@"ft"]) {
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:10]
                          range: NSMakeRange(0,14)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:20]
                          range: NSMakeRange([currentElevation length]-3,3)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                          range: NSMakeRange(14,[currentElevation length]-16)];
    } else{
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:10]
                          range: NSMakeRange(0,14)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Helvetica" size:20]
                          range: NSMakeRange([currentElevation length]-2,2)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:34]
                          range: NSMakeRange(14,[currentElevation length]-16)];
        
    }
    
    netElevationLabel.attributedText = attString;
    
}
- (void) getWeatherInformation:(CLLocationCoordinate2D) coordinate andString:(NSString *) unit{
    
    ForecastKit *forecast = [[ForecastKit alloc] initWithAPIKey:@"5ec8baf4febfad7c3dda0b2cfbffcc1a"];
    
    [forecast getDailyForcastForLatitude:coordinate.latitude longitude:coordinate.longitude success:^(NSArray *responseArray) {
        
        NSMutableDictionary *dict = [responseArray objectAtIndex:0];
        
        temperature = [dict objectForKey:@"temperature"];
        if ([unit isEqualToString:@"US"]) {
            
            [self setWeather:[NSString stringWithFormat:@"%.0f", [temperature doubleValue]]];

        } else{
            
            [self setWeather:[NSString stringWithFormat:@"%.0f", ([temperature doubleValue]-32 * (5/9))]];
        }
        
        
        
        weatherSummary = [dict objectForKey:@"summary"];
        [self setDetailWeather:[NSString stringWithFormat:@"%@", weatherSummary]];
        
        dict = [[responseArray objectAtIndex:1] objectAtIndex:0];
        NSNumber *sunset = [dict objectForKey:@"sunsetTime"];
        NSNumber *sunrise = [dict objectForKey:@"sunriseTime"];
        
        NSDate *sunriseTime = [NSDate dateWithTimeIntervalSince1970:[sunrise doubleValue]];
        NSDate *sunsetTime = [NSDate dateWithTimeIntervalSince1970:[sunset doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Format the elapsed time and set it to the label
        sunriseTimeString = [dateFormatter stringFromDate:sunriseTime];
        sunsetTimeString = [dateFormatter stringFromDate:sunsetTime];
        
        [self setSunrise:sunriseTimeString];
        [self setSunset:sunsetTimeString];
   
    } failure:^(NSError *error){
        
        NSLog(@"Daily %@", error.description);
        
    }];
    
    
    


   
}
- (void) setWeather:(NSString *) weather{
    
    NSString *currentWeather = [NSString stringWithFormat:@"%@o", weather];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:currentWeather];
    
    
    NSInteger num1 = 1;
    CFNumberRef num2 = CFNumberCreate(NULL, kCFNumberNSIntegerType, &num1);
    
        [attString addAttribute: (id)kCTSuperscriptAttributeName
                          value:  (__bridge id)(num2)
                          range: NSMakeRange([currentWeather length]-1,1)];
        
        [attString addAttribute: NSFontAttributeName
                          value:  [UIFont fontWithName:@"Arial-BoldMT" size:50]
                          range: NSMakeRange(0,[currentWeather length]-1)];
    
    weatherLabel.attributedText = attString;
    
    
}
- (void) setDetailWeather:(NSString *) detailWeather{
    
    detailWeatherLabel.text = detailWeather;
    
}
- (void) setSunrise:(NSString *) sunrise{
    
    NSString *sunriseString = [NSString stringWithFormat:@"Sunrise\n%@", sunrise];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:sunriseString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:10]
                      range: NSMakeRange(0,8)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:30]
                      range: NSMakeRange(8,[sunriseString length]-8)];
    
    sunriseLabel.attributedText = attString;
    
}
- (void) setSunset:(NSString *) sunset{
    
    NSString *sunsetString = [NSString stringWithFormat:@"Sunset\n%@", sunset];
    
    NSMutableAttributedString *attString =
    [[NSMutableAttributedString alloc]
     initWithString:sunsetString];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:10]
                      range: NSMakeRange(0,7)];
    
    [attString addAttribute: NSFontAttributeName
                      value:  [UIFont fontWithName:@"Arial-BoldMT" size:30]
                      range: NSMakeRange(7,[sunsetString length]-7)];
    
    sunsetLabel.attributedText = attString;

    
}


@end
