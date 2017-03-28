//
//  RootViewController.m
//  DKSCamera
//
//  Created by aDu on 2017/3/28.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenBounds   [UIScreen mainScreen].bounds
#define kScreenWidth  kScreenBounds.size.width*1.0
#define kScreenHeight kScreenBounds.size.height*1.0
@interface RootViewController ()

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *input;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCamera];
    [self initView];
}

- (void)customCamera{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成会话，用来结合输入输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
//    [self.session startRunning];
}

- (void)initView
{
    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    _startBtn.frame = CGRectMake(120, 200, 60, 30);
    _startBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_startBtn];
    
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stopBtn setTitle:@"结束" forState:UIControlStateNormal];
    [_stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    _stopBtn.backgroundColor = [UIColor orangeColor];
    _stopBtn.frame = CGRectMake(120, 300, 60, 30);
    [self.view addSubview:_stopBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始启动
    [self.session startRunning];
}

- (void)start
{
    for (int i = 0; i < 10; i++) {
        [NSThread sleepForTimeInterval:1];
        if (i % 2 == 0) {
            [self.device lockForConfiguration:nil];
            [self.device setTorchMode:AVCaptureTorchModeOn]; //开
            [self.device unlockForConfiguration];
        } else {
            [self.device lockForConfiguration:nil];
            [self.device setTorchMode: AVCaptureTorchModeOff]; //关
            [self.device unlockForConfiguration];
        }
    }
}

- (void)stop
{
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: AVCaptureTorchModeOff]; //关
    [self.device unlockForConfiguration];
}

- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

@end
