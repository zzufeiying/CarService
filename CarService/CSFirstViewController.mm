//
//  CSFirstViewController.m
//  CarService
//
//  Created by Chao on 13-9-12.
//  Copyright (c) 2013年 Chao. All rights reserved.
//

#import "CSFirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlockActionSheet.h"
#import "CSCarManageViewController.h"
#import "CSAddCarViewController.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "TSMessage.h"

@interface CSFirstViewController ()

@end

@implementation CSFirstViewController

#pragma mark - view lifecycle
-(void)init_NaviView
{
    [ApplicationPublic selfDefineNaviBar:self.navigationController.navigationBar];
    self.navigationItem.title=@"首页";
    
    //按钮
    UIButton* mangerBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60/2.0+4, 46/2.0)];
    [mangerBtn setImage:[UIImage imageNamed:@"shouye_btn1.png"] forState:UIControlStateNormal];
    [mangerBtn setImage:[UIImage imageNamed:@"shouye_btn1_press.png"] forState:UIControlStateHighlighted];
    [mangerBtn addTarget:self action:@selector(mangerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:mangerBtn] autorelease];
    [mangerBtn release];
    
    //信息按钮
    UIButton* msgBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60/2.0+8, 46/2.0+5)];
    [msgBtn setImage:[UIImage imageNamed:@"shouye_msg.png"] forState:UIControlStateNormal];
    [msgBtn setImage:[UIImage imageNamed:@"shouye_msg_press.png"] forState:UIControlStateHighlighted];
    [msgBtn addTarget:self action:@selector(msgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    {
        //消息数
        UILabel* numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        [numLabel setTag:1001];
        [numLabel setCenter:CGPointMake(CGRectGetMaxX(msgBtn.frame)-6.5, CGRectGetMinY(msgBtn.frame)+6)];
        [numLabel setBackgroundColor:[UIColor clearColor]];
        [numLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        [numLabel setFont:[UIFont systemFontOfSize:8]];
        [numLabel setTextColor:[UIColor whiteColor]];
        [numLabel setText:@"3"];
        numLabel.layer.cornerRadius=CGRectGetWidth(numLabel.frame)/2.0;
        numLabel.layer.borderWidth=1.0;
        numLabel.layer.borderColor=[UIColor clearColor].CGColor;
        [msgBtn addSubview:numLabel];
        [numLabel release];
    }
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:msgBtn] autorelease];
    [msgBtn release];
    
}

-(void)setUpLabel:(UIView*)superView with_tag:(int)tag with_frame:(CGRect)frame with_text:(NSString*)text with_Alignment:(NSTextAlignment)alignment
{
    UILabel* aLabel=[[UILabel alloc] initWithFrame:frame];
    if (tag>=0) {
        [aLabel setTag:tag];
    }
    [aLabel setBackgroundColor:[UIColor clearColor]];
    [aLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [aLabel setTextAlignment:alignment];
    [aLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [aLabel setTextColor:[UIColor whiteColor]];
    aLabel.numberOfLines=0;
    aLabel.lineBreakMode=NSLineBreakByWordWrapping;
    [aLabel setText:text];
    [superView addSubview:aLabel];
    [aLabel release];
 }

-(void)init_scrollView
{
    float x, y, width, height;

    x=0; y=0; width=320;
    if (Is_iPhone5) {
        height=1136/2.0;
    }else{
        height=960/2.0;
    }
    //背景
    UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (Is_iPhone5) {
        [bgImageView setImage:[UIImage imageNamed:@"shouye_iphone4.png"]];
    }else{
        [bgImageView setImage:[UIImage imageNamed:@"shouye_iphone5.png"]];
    }
    [self.view addSubview:bgImageView];
    [bgImageView release];

    x=10; y=0; width=320-10*2; height=40+278/2+15.0+20+243/2.0;
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [scrollView setTag:101];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:scrollView];
    [scrollView release];
    
    //添加内容视图
    x=0; y=40; height=278/2.0+15;
    UIView* weatherView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [weatherView setTag:201];
    weatherView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:weatherView];
    [weatherView release];
    {
        float x, y, width, height;
        //背景
        x=0; y=0; width=320-10*2; height=278/2.0+15;
        UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImageView setImage:[UIImage imageNamed:@"shouye_tianqi_bg.png"]];
        [weatherView addSubview:bgImageView];
        [bgImageView release];
        
        //定位图标
        x=10; y=15; width=17/2.0; height=23/2.0;
        UIImageView* locationImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [locationImgView setImage:[UIImage imageNamed:@"shouye_location.png"]];
        [weatherView addSubview:locationImgView];
        [locationImgView release];
        //定位城市
        x=x+width+3; y=10; width=80; height=22;
        [self setUpLabel:weatherView with_tag:1001 with_frame:CGRectMake(x, y, width, height) with_text:@"北京市" with_Alignment:NSTextAlignmentLeft];
        //天气
        x=10; y=y+height+10; width=100;
        [self setUpLabel:weatherView with_tag:1002 with_frame:CGRectMake(x, y, width, height) with_text:@"多云" with_Alignment:NSTextAlignmentLeft];
        //风力
        y=y+height+10;
        [self setUpLabel:weatherView with_tag:1003 with_frame:CGRectMake(x, y, width, height) with_text:@"微风" with_Alignment:NSTextAlignmentLeft];
        
        //日期
        x=CGRectGetWidth(weatherView.frame)-100; y=10;
        NSString *string_time=@"";
        NSString *week_day=@"";
        {
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
             string_time = [formatter stringFromDate:date];
            
            [formatter setDateFormat:@"EEEE"];
             week_day = [formatter stringFromDate:date];
            
            [formatter release];
        }
        [self setUpLabel:weatherView with_tag:1004 with_frame:CGRectMake(x, y, width, height) with_text:string_time with_Alignment:NSTextAlignmentLeft];
        //星期几
        y=y+height+10;
        [self setUpLabel:weatherView with_tag:1005 with_frame:CGRectMake(x, y, width, height) with_text:week_day with_Alignment:NSTextAlignmentLeft];
        //明日限行
        y=y+height+10; width=13*5;
        [self setUpLabel:weatherView with_tag:-1 with_frame:CGRectMake(x, y, width, height) with_text:@"今日限行:" with_Alignment:NSTextAlignmentLeft];
        //限行尾数1
        x=x+width-3; y=y+2; width=15; height=16;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1006 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1006];
            if (aLabel) {
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        //限行尾数2
        x=x+width+2;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_shuzi_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1007 with_frame:CGRectMake(x, y, width, height) with_text:@"X" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1007];
            if (aLabel) {
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        
        //天气图片
        x=0; y=0; width=90; height=90;
        UIImageView* weatherImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [weatherImgView setTag:1008];
        [weatherImgView setCenter:CGPointMake(CGRectGetMidX(weatherView.frame), CGRectGetMinY(weatherView.frame)-35)];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1002];
            NSString* imgStr=[NSString stringWithFormat:@"%@.png",aLabel.text];
            [weatherImgView setImage:[UIImage imageNamed:imgStr]];
        }
        [weatherView addSubview:weatherImgView];
        [weatherImgView release];
        //温度
        x=(CGRectGetWidth(weatherView.frame)-200/2.0)/2.0-10; y=66; width=200/2.0; height=30;
        {
            UIImageView* bgImgView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [bgImgView setImage:[UIImage imageNamed:@"shouye_wendu_bg.png"]];
            [weatherView addSubview:bgImgView];
            [bgImgView release];
        }
        [self setUpLabel:weatherView with_tag:1009 with_frame:CGRectMake(x, y, width, height) with_text:@"28℃-30℃" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1009];
            if (aLabel) {
                [aLabel setFont:[UIFont systemFontOfSize:18]];
                [aLabel setTextColor:[UIColor blackColor]];
            }
        }
        
        //提示信息
        x=15; y=105; width=CGRectGetWidth(weatherView.frame)-x*2; height=30;
        [self setUpLabel:weatherView with_tag:1010 with_frame:CGRectMake(x, y, width, height) with_text:@"提示：未来24小时天气变换，不宜洗车" with_Alignment:NSTextAlignmentCenter];
        {
            UILabel* aLabel=(UILabel*)[weatherView viewWithTag:1010];
            if (aLabel) {
                [aLabel setFont:[UIFont systemFontOfSize:14]];
                [aLabel setTextColor:[UIColor colorWithRed:254/255.0 green:205/255.0 blue:67/255.0 alpha:1.0]];
            }
        }
    }
    
    //添加车辆
    y=y+height+20; height=243/2.0;
    UIView* addCarView=[[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [addCarView setTag:202];
    addCarView.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:addCarView];
    [addCarView release];
    {
        float x, y, width, height;
        //背景
        x=0; y=0; width=320-10*2; height=243/2.0;
        UIImageView* bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [bgImageView setImage:[UIImage imageNamed:@"shouye_tianjiacheliang_bg.png"]];
        [addCarView addSubview:bgImageView];
        [bgImageView release];
        
        //如果无添加记录 则显示添加按钮
        {
            UIView* containView=[[UIView alloc] initWithFrame:bgImageView.bounds];
            [containView setTag:1001];
            [addCarView addSubview:containView];
            [containView release];
            
            //添加车辆按钮
            x=0; y=0; width=339/2.0; height=50/2.0;
            UIButton* addCarBtn=[[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [addCarBtn setTag:10001];
            [addCarBtn setCenter:CGPointMake(CGRectGetMidX(addCarView.bounds), CGRectGetMidY(addCarView.bounds))];
            [addCarBtn setShowsTouchWhenHighlighted:YES];
            [addCarBtn setImage:[UIImage imageNamed:@"shouye_tianjiacheliang_btn.png"] forState:UIControlStateNormal];
            [addCarBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [containView addSubview:addCarBtn];
            [addCarBtn release];
        }
        //如果添加过记录 则显示最后一个添加记录
        {
            UIView* containView=[[UIView alloc] initWithFrame:bgImageView.bounds];
            [containView setTag:1002];
            [addCarView addSubview:containView];
            [containView release];
            
            //图片
            x=10; y=15; width=115; height=addCarView.bounds.size.height-y*2;
            UIImageView* aImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [aImageView setImage:[UIImage imageNamed:@"tianjiacheliang_pic.png"]];
            [containView addSubview:aImageView];
            [aImageView release];
            
            //车牌
            x=x+width+10; width=addCarView.bounds.size.width-x-10; height=(addCarView.bounds.size.height-y*2)/2.0;
            [self setUpLabel:containView with_tag:10001 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
            //车架号
            y=y+height; y=y+1;
            [self setUpLabel:containView with_tag:10002 with_frame:CGRectMake(x, y, width, height) with_text:@"" with_Alignment:NSTextAlignmentLeft];
        }

        NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
        if (alreadyAry) {
            UIView* containView=[addCarView viewWithTag:1001];
            if (containView) {
                containView.alpha=0;
            }
        }else{
            UIView* containView=[addCarView viewWithTag:1002];
            if (containView) {
                containView.alpha=0;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor scrollViewTexturedBackgroundColor];
	// Do any additional setup after loading the view, typically from a nib.
    [self init_NaviView];
    [self init_scrollView];
    
    //网络获取数据
    [self startHttpRequest];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:101];
    if (scrollView) {
        UIView* addCarView=[scrollView viewWithTag:202];
        if (addCarView) {
            NSArray* alreadyAry=[[NSUserDefaults standardUserDefaults] objectForKey:CSAddCarViewController_carList];
            if (alreadyAry) {
                UIView* containView=[addCarView viewWithTag:1001];
                if (containView) {
                    containView.alpha=0;
                }
                containView=[addCarView viewWithTag:1002];
                if (containView) {
                    containView.alpha=1;
                }
                
                //更新数据 为最后一个
                {
                    NSString* signStr=[[alreadyAry lastObject] objectForKey:CSAddCarViewController_carSign];
                    NSString* standStr=[[alreadyAry lastObject] objectForKey:CSAddCarViewController_carStand];
                    UIView* containView=[addCarView viewWithTag:1002];
                    if (containView) {
                        UILabel* aLabel=(UILabel*)[containView viewWithTag:10001];
                        if (aLabel) {
                            [aLabel setText:[NSString stringWithFormat:@"车牌号：%@",signStr]];
                        }
                        
                        aLabel=(UILabel*)[containView viewWithTag:10002];
                        if (aLabel) {
                            [aLabel setText:[NSString stringWithFormat:@"车架号：%@",standStr]];
                        }
                    }
                }
            }else{
                UIView* containView=[addCarView viewWithTag:1002];
                if (containView) {
                    containView.alpha=0;
                }
                containView=[addCarView viewWithTag:1001];
                if (containView) {
                    containView.alpha=1;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
}

#pragma mark 网络相关

-(void)startHttpRequest{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self request_TrafficControls];
    });
}

//今日限行
-(void)request_TrafficControls
{
    NSString *urlStr = [URL_TrafficControls stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeOutSeconds:60.0];
    [request setRequestMethod:@"POST"];
    [request setCompletionBlock:^{
        //NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //NSString *testResponseString = [[[[[[NSString alloc] initWithData:[request responseData] encoding:encoding] autorelease] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //CustomLog(@"<<Chao-->CSFirstViewController-->request_TrafficControls-->testResponseString:%@",testResponseString);
        NSDictionary *requestDic =[[request responseString] JSONValue];
        CustomLog(@"<<Chao-->CSFirstViewController-->request_TrafficControls-->requestDic:%@",requestDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([requestDic objectForKey:@"str"]) {
                NSString* backStr=[requestDic objectForKey:@"str"];
                if ([backStr isEqualToString:@"-1"]) {
                    
                }else{
                    if (backStr.length>0) {
                        [self updateTextForLabel:[backStr substringWithRange:NSMakeRange(0, 1)] with_superViewTag:201 with_LabelTag:1006];
                    }
                    if (backStr.length>1) {
                        [self updateTextForLabel:[backStr substringWithRange:NSMakeRange(1, 1)] with_superViewTag:201 with_LabelTag:1007];
                    }
                }
            }
        });
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:NSLocalizedString(@"错误", nil) with_detail:NSLocalizedString(@"加载今日限行数据失败，请检验网络！", nil) with_type:TSMessageNotificationTypeError];
        });
    }];
    [request startAsynchronous];
}

-(void)updateTextForLabel:(NSString*)text with_superViewTag:(int)superTag  with_LabelTag:(int)labelTag
{
    UIScrollView* scrollView=(UIScrollView*)[self.view viewWithTag:101];
    if (scrollView) {
        UIView* superView=[scrollView viewWithTag:superTag];
        if (superView) {
            UILabel* aLabel=(UILabel*)[superView viewWithTag:labelTag];
            aLabel.text=[NSString stringWithFormat:@"%@",text];
        }
    }
}

-(void)showMessage:(NSString*)titleStr with_detail:(NSString*)detailStr with_type:(TSMessageNotificationType)type
{
    [TSMessage showNotificationInViewController:self
                                          title:titleStr
                                       subtitle:detailStr
                                          image:nil
                                           type:type
                                       duration:4.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                            canBeDismisedByUser:YES];
}

#pragma mark - 点击事件
-(void)msgBtnClick:(id)sender
{
    
}

-(void)addBtnClick:(id)sender
{
    CSAddCarViewController* ctrler=[[CSAddCarViewController alloc] init];
    [self.navigationController pushViewController:ctrler animated:YES];
    [ctrler release];
}

-(void)mangerBtnClick:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@""];
    [sheet setCancelButtonWithTitle:@"取消" block:nil];
    [sheet setDestructiveButtonWithTitle:@"车辆管理" block:^{
        CSCarManageViewController* ctrler=[[CSCarManageViewController alloc] init];
        [self.navigationController pushViewController:ctrler animated:YES];
        [ctrler release];
    }];
    //[sheet addButtonWithTitle:@"" block:^{
    //
    //}];
    [sheet showInView:self.view];

}

@end
