//
//  ViewController.m
//  Privacy
//
//  Created by Hayden on 2014. 10. 29..
//  Copyright (c) 2014년 OliveStory. All rights reserved.
//

#import "ViewController.h"
#import <Ackon/Ackon.h>
@interface ViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *optSwitch;
@property (nonatomic, strong) ACKAckonManager *ackonManager;
@end
typedef enum : NSUInteger {
    AlertTypeEnable,
    AlertTypeDisable,
} AlertType;
@implementation ViewController
- (IBAction)switchAction:(UISwitch *)sender {
    if(sender.on){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"위치정보를 서버에 전송합니다. 동의하십니까?"
                                                           delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인",nil];
        alertView.tag = AlertTypeEnable;
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버에 저장된 모든 위치정보 값이 지워집니다."
                                                           delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인",nil];
        alertView.tag = AlertTypeDisable;
        [alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ackonManager = [[ACKAckonManager alloc] initWithServerURL:[NSURL URLWithString:@"http://cms.ackon.co.kr/"] serviceIdentifier:@"SBA14100002"];
    self.optSwitch.on = _ackonManager.userConfirm;//유저 동의 상태를 스위치UI에 적용
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == AlertTypeEnable){
        if(buttonIndex == 1){
            [self.ackonManager requestEnabled:^(BOOL success, NSError *error) {//유저등록 요청
                self.optSwitch.on = success;
                if(success){
                    [[[UIAlertView alloc] initWithTitle:@"성공" message:@"성공하였습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"실패" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
                }
            }];
        }else{
            [self.optSwitch setOn:NO animated:YES];
        }
    }else if (alertView.tag == AlertTypeDisable){
        if(buttonIndex == 1){
            [self.ackonManager requestDisabled:^(BOOL success, NSError *error) {//유저정보삭제 요청
                self.optSwitch.on = !success;
                if(success){
                    [[[UIAlertView alloc] initWithTitle:@"성공" message:@"성공하였습니다" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
                }else{
                    [[[UIAlertView alloc] initWithTitle:@"실패" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil] show];
                }
            }];
        }
    }
}
@end
