//
//  StoreApplySubmitViewController.m
//  yangsheng
//
//  Created by jam on 17/7/16.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "StoreApplySubmitViewController.h"
#import "StoreHttpTool.h"
#import "UserModel.h"

#import "PopOverNavigationController.h"
#import "StoreCitySelectionViewController.h"
#import "StoreApplyResultViewController.h"
#import "StoreApplyProtocolViewController.h"

#import "CitySelectionPicker.h"
#import "PickerShadowContainer.h"

@interface StoreApplySubmitViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *idcardTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;
@property (weak, nonatomic) IBOutlet UIButton *negativeButton;
@property (weak, nonatomic) IBOutlet UIImageView *positiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *negativeImage;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@end

@implementation StoreApplySubmitViewController
{
    BOOL isPosi;
    
    NSString* positiveImageUrl;
    NSString* negativeImageUrl;
    
    CitySelectionPicker* cityPicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"申请开店";
    
    [self.refreshControl removeFromSuperview];
    
    self.nameTextField.delegate=self;
    self.phoneTextField.delegate=self;
    self.idcardTextField.delegate=self;
    self.areaTextField.delegate=self;
    self.addressTextField.delegate=self;
    
    if (self.applyResult) {
        self.nameTextField.text=self.applyResult.name;
        self.phoneTextField.text=self.applyResult.tel;
        
        self.areaTextField.text=self.applyResult.area;
        self.addressTextField.text=self.applyResult.address;
        [self.positiveButton setTitle:self.applyResult.positive forState:UIControlStateSelected];
        [self.negativeButton setTitle:self.applyResult.negative forState:UIControlStateSelected];
        [self.positiveImage sd_setImageWithURL:[self.applyResult.positive urlWithMainUrl]];
        [self.negativeImage sd_setImageWithURL:[self.applyResult.negative urlWithMainUrl]];
    }
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectedArea:) name:SelectedNewCityNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)didSelectedArea:(NSNotification*)noti
//{
//    NSArray* cities=[noti.userInfo valueForKey:CityLevelCity];
//    if (cities.count>0) {
//        NSString* cityName=@"";
//        NSMutableArray* names=[NSMutableArray array];
//        for (CityModel* ci in cities) {
//            NSString* cn=ci.name;
//            if (cn.length>0) {
//                [names addObject:cn];
//            }
//        }
//        cityName=[names componentsJoinedByString:@""];
//        self.areaTextField.text=cityName;
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }
    return UITableViewAutomaticDimension;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}
- (IBAction)openMap:(id)sender {
//    StoreCitySelectionViewController* ob=[[StoreCitySelectionViewController alloc]initWithStyle:UITableViewStylePlain];
//    ob.isStoreLocation=YES;
//    PopOverNavigationController* pop=[[PopOverNavigationController alloc]initWithRootViewController:ob sourceView:self.mapButton];
//    [self presentViewController:pop animated:YES completion:nil];
    
    [self.view endEditing:YES];
    if (cityPicker==nil) {
        cityPicker=[CitySelectionPicker defaultCityPickerWithSections:2];
    }
    [PickerShadowContainer showPickerContainerWithView:cityPicker completion:^{
        NSString* cityName=@"";
        NSMutableArray* names=[NSMutableArray array];
        NSArray* cityssss=cityPicker.selectedCitys;
        for (CityModel* ci in cityssss) {
            NSString* cn=ci.name;
            if (cn.length>0) {
                [names addObject:cn];
            }
        }
        cityName=[names componentsJoinedByString:@""];
        self.areaTextField.text=cityName;
    }];
}
- (IBAction)uploadPositiveImage:(id)sender {
    [self selectImageToPositive:YES];
}
- (IBAction)uploadNegativeImage:(id)sender {
    [self selectImageToPositive:NO];
}

- (IBAction)goToSubmit:(id)sender {
    NSString* name=self.nameTextField.text;
    NSString* phone=self.phoneTextField.text;
    NSString* idcard=self.idcardTextField.text;
    NSString* area=self.areaTextField.text;
    NSString* address=self.addressTextField.text;
    NSString* positive=[self.positiveButton titleForState:UIControlStateSelected];
    NSString* negative=[self.negativeButton titleForState:UIControlStateSelected];
    
    if (![positive containsString:@"jpg"]) {
        positive=@"";
    }
    if (![negative containsString:@"jpg"]) {
        negative=@"";
    }
    
    BOOL ok=name.length>0&&phone.length>0&&idcard.length>0&&area.length>0&&address.length>0&&positive.length>0&&negative.length>0&&[phone isMobileNumber]&&[idcard isIdNumber];
    if (ok) {
        [MBProgressHUD showProgressMessage:@"正在申请"];
        [StoreHttpTool applyStoreSubmitName:name tel:phone idcard:idcard area:area address:address positive:positive negative:negative token:[[UserModel getUser]access_token] success:^(BOOL applied, NSString *msg) {
            if (applied) {
                [MBProgressHUD showSuccessMessage:msg];
                [MBProgressHUD showProgressMessage:@"请稍后"];
                [StoreHttpTool getApplyResultWithToken:[[UserModel getUser]access_token] success:^(StoreApplyModel *applyModel) {
                    [MBProgressHUD hide];
                    if (applyModel.name.length>0) {
                        //yes
//                        StoreApplyResultViewController* pro=[[UIStoryboard storyboardWithName:@"Store" bundle:nil]instantiateViewControllerWithIdentifier:@"StoreApplyResultViewController"];
//                        pro.applyResult=applyModel;
//                        [self.navigationController pushViewController:pro animated:YES];
                        //
                        StoreApplyResultViewController* pro=nil;
                        BOOL contains=NO;
                        NSArray* ss=self.navigationController.viewControllers;
                        for (UIViewController* vc in ss) {
                            if([vc isKindOfClass:[StoreApplyResultViewController class]])
                            {
                                pro=(StoreApplyResultViewController*)vc;
                                contains=YES;
                            }
                        }
                        if(pro==nil)
                        {
                            pro=[[UIStoryboard storyboardWithName:@"Store" bundle:nil]instantiateViewControllerWithIdentifier:@"StoreApplyResultViewController"];
                        }
                        pro.applyResult=applyModel;
                        if (contains) {
                            [self.navigationController popToViewController:pro animated:YES];
                        }
                        else
                        {
                            [self.navigationController pushViewController:pro animated:YES];
                            ss=[self.navigationController viewControllers];
                            NSMutableArray* vcs=[NSMutableArray arrayWithArray:ss];
                            for (UIViewController* vc in ss) {
                                if ([vc isKindOfClass:[self class]]||[vc isKindOfClass:[StoreApplyProtocolViewController class]]) {
                                    [vcs removeObject:vc];
                                }
                            }
                            [self.navigationController setViewControllers:vcs];
                        }
                    }
                }];
            }
            else
            {
                [MBProgressHUD showErrorMessage:msg];
            }
        }];
    }
    else if(name.length==0)
    {
        [MBProgressHUD showErrorMessage:@"请填写姓名"];
    }
    else if(![idcard isIdNumber])
    {
        [MBProgressHUD showErrorMessage:@"请填写正确的身份证号码"];
    }
    else if(![phone isMobileNumber])
    {
        [MBProgressHUD showErrorMessage:@"请填写正确的手机号码"];
    }
    else if(area.length==0)
    {
        [MBProgressHUD showErrorMessage:@"请选择地区"];
    }
    else if(address.length==0)
    {
        [MBProgressHUD showErrorMessage:@"请填写详细地址"];
    }

    else
    {
        if (positive.length==0||negative.length==0) {
            [MBProgressHUD showErrorMessage:@"请上传身份证照片"];
        }
        else
        {
            [MBProgressHUD showErrorMessage:@"请填写完整个人信息"];
        }
    }
}
- (IBAction)goToProtocal:(id)sender {
    BaseWebViewController* proto=[[BaseWebViewController alloc]initWithUrl:[html_gsrdprivate urlWithMainUrl]];
    proto.title=@"服务条款";
    [self.navigationController pushViewController:proto animated:YES];
}

-(void)selectImageToPositive:(BOOL)isPositive
{
    isPosi=isPositive;
    UIImagePickerController* pick=[[UIImagePickerController alloc]init];
    pick.delegate=self;
    
    UIAlertController* alert=[UIAlertController alertControllerWithTitle:@"选择身份证照片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        
        alert.popoverPresentationController.sourceView = isPosi?self.positiveButton:self.negativeButton;
        UIView* sourceV=alert.popoverPresentationController.sourceView;
        alert.popoverPresentationController.sourceRect = CGRectMake(sourceV.center.x, sourceV.center.y, 0, 0);
        alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType=UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self presentViewController:pick animated:YES completion:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        pick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self presentViewController:pick animated:YES completion:nil];
        }
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* originImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    __weak UIImageView* whichImageView=isPosi?self.positiveImage:self.negativeImage;
    __weak UIButton* whichButton=isPosi?self.positiveButton:self.negativeButton;
    
    whichButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [whichButton setTitle:@"上传中..." forState:UIControlStateDisabled];
    whichButton.enabled=NO;
    whichImageView.image=originImage;
    [whichButton setTitle:@"" forState:UIControlStateSelected];
    [StoreHttpTool uploadIDCard:originImage token:[[UserModel getUser]access_token] success:^(NSString *str) {
        [whichButton setTitle:@"重新选择" forState:UIControlStateNormal];
        [whichButton setTitle:str forState:UIControlStateSelected];
        whichButton.enabled=YES;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.areaTextField) {
        [self openMap:nil];
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==self.nameTextField) {
        [self.phoneTextField becomeFirstResponder];
    }
    else if(textField==self.phoneTextField)
    {
        [self.idcardTextField becomeFirstResponder];
    }
    else if(textField==self.idcardTextField)
    {
        [self.addressTextField becomeFirstResponder];
    }
    return YES;
}

@end
