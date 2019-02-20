//
//  ViewController.m
//  wxStore
//
//  Created by xiangyu on 2019/2/18.
//  Copyright © 2019 xiangyu. All rights reserved.
//
#import <ContactsUI/ContactsUI.h>
#import "ViewController.h"
static NSString *emailAddresses =@"123456789@qq.com";
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)create:(id)sender {
    for (int i=0; i <= _textField.text.integerValue; i++) {
        [self addContact:[self createServiceContactWithName:@"wx小店好友" phoneNumber:[self getRandomPhoneNumber]]];
    }
}

- (IBAction)deleteAll:(id)sender {
    NSArray *countacts = [self isExitContact:emailAddresses];
    if (countacts.count > 0) {
        for (CNContact* countact in countacts) {
            CNMutableContact *mutableCountact =[countact mutableCopy];
            [self deleteContact:mutableCountact];
        };
    }
}
-(NSString *)getRandomPhoneNumber {
    NSArray *arr = @[ @"130",
                      @"131",
                      @"132",
                      @"133",
                      @"134",
                      @"135",
                      @"136",
                      @"137",
                      @"138",
                      @"139",
                      @"147",
                      @"150",
                      @"151",
                      @"152",
                      @"153",
                      @"155",
                      @"156",
                      @"157",
                      @"158",
                      @"159",
                      @"186",
                      @"187",
                      @"188",
                      @"176",
                      @"177"];
    
    int random = (arc4random() % 100000000);
    NSString * phoneNuber = arr[(arc4random() % 25)];
    NSMutableString * randomString = [NSMutableString stringWithFormat:@"%d",random];
    NSMutableString * zeroString = [NSMutableString stringWithFormat:@"%@",@"00000000"];
    if (randomString.length < 8) {
        [zeroString replaceCharactersInRange:NSMakeRange(8-randomString.length, randomString.length) withString:randomString];
    } else {
        zeroString = randomString;
    }
    phoneNuber = [NSString stringWithFormat:@"+86%@%@",phoneNuber,zeroString];
    NSLog(@"%@",phoneNuber);
    return phoneNuber;
}
/**
 创建客服信息
 */
- (CNMutableContact *)createServiceContactWithName:(NSString *)name phoneNumber:(NSString *)phoneNumber  {
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    contact.organizationName = name;
    CNPhoneNumber *mobileNumber = [[CNPhoneNumber alloc] initWithStringValue:phoneNumber];
    CNLabeledValue *mobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberMobile value:mobileNumber];
    CNLabeledValue *emailAddressesValue = [[CNLabeledValue alloc] initWithLabel:CNLabelEmailiCloud value:emailAddresses];
    contact.phoneNumbers = @[mobilePhone];
    contact.emailAddresses = @[emailAddressesValue];
    return contact;
}
/**
 添加联系人
 */
- (void)addContact:(CNMutableContact *)contact {
    // 创建联系人请求
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    // 写入联系人
    CNContactStore *store = [[CNContactStore alloc] init];
    [store executeSaveRequest:saveRequest error:nil];
}
/**
 删除客服信息
 */
- (void)deleteContact:(CNMutableContact *)contact{
    // 创建联系人请求
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest deleteContact:contact];
    // 写入操作
    CNContactStore *store = [[CNContactStore alloc] init];
    [store executeSaveRequest:saveRequest error:nil];
}
/**
 判断是否存在指定联系人
 */
- (NSArray *)isExitContact:(NSString *)emailAddresses {
    CNContactStore *store = [[CNContactStore alloc] init];
    //检索条件
    NSPredicate *predicate = [CNContact predicateForContactsMatchingEmailAddress:emailAddresses];
    //过滤的条件
    NSArray *keysToFetch = @[CNContactEmailAddressesKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]];
    NSArray *contact = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
    return contact;
}
@end
