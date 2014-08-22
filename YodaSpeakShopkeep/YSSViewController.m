//
//  YSSViewController.m
//  YodaSpeakShopkeep
//
//  Created by David Segal on 8/19/14.
//  Copyright (c) 2014 dsegal. All rights reserved.
//
/*
 
 Yoda Speak
 Write a simple iOS app that takes input from the user and turns it into how Master Yoda would have said it. Damn right that is.
 Hold on picking up that Natural Language Processing book just yet. For the implementation hit the Yoda Speak API (see Yoda Speak on mashape to get started up quickly).
 Although this is obviously a tiny app, set up its architecture in an extendable manner that you would feel reasonably proud of, instead of a quick dirty implementation. Assume we'll be expanding the app to use multiple different formatters for the output (e.g. leet speak or a text-to- speech API) in the near future.
 Manage dependencies and include unit tests as you feel is appropriate. May the words be with you.
 
 */

#import "YSSViewController.h"
#import "YSSRequestManager.h"
#import "YSSTranslatedTextModel.h"

@interface YSSViewController ()

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation YSSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.inputTextView.layer.borderWidth = 1.0f;
	self.inputTextView.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendRequest:(NSString *)inputMessage
{
    if (inputMessage.length > 0)
    {
        [self blockActivity];
        YSSViewController __block *blockself = self;
        [[YSSRequestManager sharedInstance] getTranslationToYoda:inputMessage success:^(YSSTranslatedTextModel *translatedModel) {
            if (blockself)
            {
                [blockself unblockActivity];
                blockself.outputTextView.text = translatedModel.translatedText;
            }
            
        } failure:^(NSError *error) {
            if (blockself)
            {
                [blockself unblockActivity];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error sending your request, there was" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
        }];
    }
    
}

- (IBAction)sendRequestTouch:(id)sender
{
    [self.inputTextView resignFirstResponder];
    [self sendRequest:self.inputTextView.text];
}


-(void)blockActivity
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
}

-(void)unblockActivity
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if (self.activityIndicator)
    {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
