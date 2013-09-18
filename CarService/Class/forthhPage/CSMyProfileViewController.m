//
//  CSMyProfileViewController.m
//  CarService
//
//  Created by baidu on 13-9-17.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSMyProfileViewController.h"
#import "ASIFormDataRequest.h"
#import "CSAppDelegate.h"

@interface CSMyProfileViewController ()

@property (nonatomic,retain) IBOutlet UITextField *nameLabel;
@property (nonatomic,retain) IBOutlet UITextField *ageField;
@property (nonatomic,retain) IBOutlet UILabel *sexLabel;
@property (nonatomic,retain) IBOutlet UITextField *phoneField;
@property (nonatomic,retain) IBOutlet UITextField *driverLecenseField;
@property (nonatomic,retain) NSMutableDictionary *userInfo;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic,retain) IBOutlet UIView *dataPickerView;
@property (nonatomic,retain) ASIHTTPRequest *changeInfoRequest;
@property (nonatomic,retain) IBOutlet UIView *backView;

@end

@implementation CSMyProfileViewController

@synthesize nameLabel;
@synthesize ageField;
@synthesize sexLabel;
@synthesize phoneField;
@synthesize driverLecenseField;
@synthesize userInfo;
@synthesize pickerView;
@synthesize dataPickerView;
@synthesize changeInfoRequest;
@synthesize backView;

- (id)initWithInfo:(NSMutableDictionary *)info
{
    self = [self initWithNibName:@"CSMyProfileViewController" bundle:nil];
    if (self)
    {
        self.userInfo = info;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadContent
{
    self.backView.hidden = NO;
    self.nameLabel.text = [self.userInfo objectForKey:@"username"];
    self.ageField.text = [self.userInfo objectForKey:@"age"];
    self.sexLabel.text = [self.userInfo objectForKey:@"sex"];
    self.phoneField.text = [self.userInfo objectForKey:@"phone"];
    self.driverLecenseField.text = [self.userInfo objectForKey:@"drivecard"];
}

- (void)loadProfileInfo
{
    self.backView.hidden = YES;
    [self.changeInfoRequest clearDelegatesAndCancel];
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"id"];
    NSString *sessionId = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"user_info",@"action",uid,@"user_id",sessionId,@"session_id", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.changeInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];
    
    [changeInfoRequest setShouldAttemptPersistentConnection:NO];
    [changeInfoRequest setValidatesSecureCertificate:NO];
    
    [changeInfoRequest setDelegate:self];
    [changeInfoRequest setDidFinishSelector:@selector(profileRequestDidFinished:)];
    [changeInfoRequest setDidFailSelector:@selector(profileRequestDidFailed:)];
    
    [changeInfoRequest startAsynchronous];
    [self showFullActView:UIActivityIndicatorViewStyleWhite];
}

- (void)profileRequestDidFinished:(ASIFormDataRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideFullActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    int statusCode = [[requestDic objectForKey:@"status"] intValue];
    switch (statusCode)
    {
        case 0:
            self.userInfo = [NSMutableDictionary dictionaryWithDictionary:[requestDic objectForKey:@"list"]];
            [self reloadContent];
            break;
        case 2:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"session_id不正确，请稍后重试!"];
            break;
        case 3:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请稍后重试!"];
            break;
        case 4:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"消费类型不正确，请稍后重试!"];
            break;
        case 1:
        default:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
            break;
    }
    
}

- (void)profileRequestDidFailed:(ASIFormDataRequest *)request
{
    [self hideFullActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"请求失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}

- (IBAction)rightButtonItemPressed:(id)sender
{
    if (self.backView.hidden == YES)
    {
        return;
    }
    
    [self.changeInfoRequest clearDelegatesAndCancel];
    NSString *uid = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"id"];
    NSString *sessionId = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultUserInfo] objectForKey:@"session_id"];
    NSDictionary *argDic = [NSDictionary dictionaryWithObjectsAndKeys:@"edit_user_info",@"action",uid,@"user_id",sessionId,@"session_id",self.nameLabel.text,@"username",self.ageField.text,@"age",self.sexLabel.text,@"sex",self.phoneField.text,@"phone",self.driverLecenseField.text,@"drivecard", nil];
    SBJSON *jasonParser = [[SBJSON alloc] init];
    NSString *jsonArg = [[jasonParser stringWithObject:argDic error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [jasonParser release];
    
    self.changeInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@?json=%@",ServerAddress,jsonArg]]];    [changeInfoRequest setShouldAttemptPersistentConnection:NO];
    [changeInfoRequest setValidatesSecureCertificate:NO];
    
    [changeInfoRequest setDelegate:self];
    [changeInfoRequest setDidFinishSelector:@selector(editingRequestDidFinished:)];
    [changeInfoRequest setDidFailSelector:@selector(editingRequestDidFailed:)];
    
    [changeInfoRequest startAsynchronous];
    [self showActView:UIActivityIndicatorViewStyleWhite];
}

- (void)editingRequestDidFinished:(ASIFormDataRequest *)request
{
    CustomLog(@"%@",[request responseString]);
    [self hideActView];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *responseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding]autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *requestDic = [responseString JSONValue];
    CustomLog(@"login request request dic:%@",requestDic);
    if (nil == requestDic || nil == [requestDic objectForKey:@"status"])
    {
        [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
        return;
    }
    int statusCode = [[requestDic objectForKey:@"status"] intValue];
    switch (statusCode)
    {
        case 0:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改成功!"];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"session_id不正确，请稍后重试!"];
            break;
        case 3:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"用户id不正确，请稍后重试!"];
            break;
        case 4:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"手机号已存在，请更换后重试!"];
            break;
        case 5:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"驾驶证号已存在，请更换后重试!"];
            break;
        case 1:
        default:
            [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请稍后重试!"];
            break;
    }
    
}

- (void)editingRequestDidFailed:(ASIFormDataRequest *)request
{
    [self hideActView];
    [[Util sharedUtil] showAlertWithTitle:@"" message:@"修改失败，请检查网络连接!"];
    return;
    CustomLog(@"%@",[request responseString]);
}


- (IBAction)comfirmActionPressed:(id)sender
{
    if ([self.pickerView selectedRowInComponent:0] == 0)
    {
        [self.userInfo setObject:@"男" forKey:@"sex"];
    }
    else
    {
        [self.userInfo setObject:@"女" forKey:@"sex"];
    }
    self.sexLabel.text = [self.userInfo objectForKey:@"sex"];
    
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.dataPickerView removeFromSuperview];
    }];
}

- (IBAction)cancelActionPressed:(id)sender
{
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    } completion:^(BOOL finish){
        [self.dataPickerView removeFromSuperview];
    }];
}

- (IBAction)showSexSelectionView:(id)sender
{
    [self hideKeyBoard];
    CSAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.dataPickerView.frame = CGRectMake(0, delegate.window.frame.size.height, 320, delegate.window.frame.size.height);
    [delegate.window addSubview:self.dataPickerView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dataPickerView.frame = CGRectMake(0, 0, 320, delegate.window.frame.size.height);
    }];
    [self.pickerView reloadAllComponents];
}

- (void)dealloc
{
    [pickerView release];
    [dataPickerView release];
    [changeInfoRequest clearDelegatesAndCancel];
    [changeInfoRequest release];
    [userInfo release];
    [nameLabel release];
    [ageField release];
    [sexLabel release];
    [phoneField release];
    [driverLecenseField release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [self getBackItem];
    self.navigationItem.rightBarButtonItem = [self getRithtItem:@"修改"];
    self.navigationItem.title = @"个人资料";
    
    //点击页面使键盘消失
    UITapGestureRecognizer* tapReconginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapReconginzer.numberOfTapsRequired = 1;
    tapReconginzer.numberOfTouchesRequired = 1;
    [self.backView addGestureRecognizer:tapReconginzer];
    [tapReconginzer release];
    
    [self loadProfileInfo];
}

- (void)hideKeyBoard
{
    [self.nameLabel resignFirstResponder];
    [self.ageField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.driverLecenseField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField       // became first responder
{
    [UIView animateWithDuration:0.3 animations:^{
        if (Is_iPhone5)
        {
            
        }
        else
        {
            if ([self.nameLabel isFirstResponder] || [self.ageField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
            }
            else if([self.phoneField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, -20, self.backView.frame.size.width, self.backView.frame.size.height);
            }
            else if([self.driverLecenseField isFirstResponder])
            {
                self.backView.frame = CGRectMake(0, -40, self.backView.frame.size.width, self.backView.frame.size.height);
            }
        }
    }];
    
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoard];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
    {
        return @"男";
    }
    else if (row == 1)
    {
        return @"女";
    }
    return  nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 35;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

@end
