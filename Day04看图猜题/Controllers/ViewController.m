//
//  ViewController.m
//  Day04看图猜题
//
//  Created by xxg415 on 2018/11/12.
//  Copyright © 2018 xxg415. All rights reserved.
//

#import "ViewController.h"
#import "Question.h"

@interface ViewController ()

@property(nonatomic,strong) NSArray *questions;
@property(nonatomic,assign)int index;
@property(nonatomic,assign) CGRect iconFrame;
@property (weak, nonatomic) IBOutlet UIButton *btnScore;
@property (weak, nonatomic) IBOutlet UILabel *lbIndex;
@property (weak, nonatomic) IBOutlet UILabel *lbTittle;
@property (weak, nonatomic) IBOutlet UIButton *btnIcon;
- (IBAction)btnBigPicture;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic)  UIButton *cover;//用来引用大图的btnCover
- (IBAction)Next;

@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *optionsView;

- (IBAction)btnTipClick:(id)sender;

@end

@implementation ViewController

-(NSArray *)questions
{
    if (_questions==nil) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil];
        NSArray *arrayDict=[NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModel=[NSMutableArray array];
        
        //遍历
        
        for (NSDictionary *dict in arrayDict) {
            Question *model=[Question questionWithDict:dict];
            [arrayModel addObject:model];
        }
        _questions=arrayModel;
    }
    return _questions;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化显示第一题
    self.index=-1;
    [self NextQuestion];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBigPicture {
    
    self.iconFrame=self.btnIcon.frame;
    
    NSLog(@"dhhdhdhdh");
    
    //创建一个与屏幕同大的按钮做遮罩层
    UIButton *btnCover=[[UIButton alloc]init];
    btnCover.frame=self.view.bounds;
    btnCover.backgroundColor=[UIColor blackColor];
    [btnCover addTarget:self action:@selector(smallClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCover];
    
    //把图片设置到上边
    [self.view bringSubviewToFront:self.btnIcon];//把控件带到最上方
    self.cover=btnCover;
    
    //用动画
    CGFloat iconW=self.view.frame.size.width;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=(self.view.frame.size.height-iconH)/2;
    
    [UIView animateWithDuration:0.7 animations:^{
        btnCover.alpha=0.6;
        self.btnIcon.frame=CGRectMake(iconX, iconY, iconW, iconH);
    }];
   
}
- (IBAction)Next {
    NSLog(@"hhhhhhhhhhhh");
    [self NextQuestion];
}

-(void)NextQuestion{
    
    self.index++;
    if (self.index==self.questions.count) {
        //NSLog(@"答题完成");
//        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"恭喜你过关" delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles: nil];
//        [actionSheet showInView:self.view];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"恭喜你答题完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return  ;
    }
    
    Question *nextQ=self.questions[self.index];
    [self setData:nextQ];
    //设置答案按钮
    [self makeAnswerButtons:nextQ];

    //设置选项按钮
    [self makeOptionsButtons:nextQ];
}

-(void)smallClick{
    
    
    [UIView animateWithDuration:0.7 animations:^{
        self.btnIcon.frame=self.iconFrame;
        self.cover.alpha=0;
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
    }];
    
}

-(void)setData:(Question *)model
{
    
    self.lbIndex.text=[NSString stringWithFormat:@"%D/%ld",(self.index+1),self.questions.count];
    self.lbTittle.text=model.tittle;
    [self.btnIcon setImage:[UIImage imageNamed:model.icon] forState:UIControlStateNormal];
    self.btnNext.enabled=self.index!=(self.questions.count-1);
}
-(void)makeAnswerButtons:(Question *)model
{
    //    while (self.answerView.subviews.firstObject) {
    //        [self.answerView.subviews.firstObject removeFromSuperview];
    //    }
    
    [self.answerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //让所有的子控件去执行一个操作，跟上边的那个功能一样，不需要自己写循环
    
    NSUInteger len=model.answer.length;
    CGFloat margin=10;
    CGFloat answerW=35;
    CGFloat answerH=35;
    CGFloat answerY=0;
    CGFloat marginLeft=(self.answerView.frame.size.width-(len*answerW)-(len-1)*margin)/2;
    for (int i=0; i<len; i++) {
        UIButton *btnAnswer=[[UIButton alloc]init];
        btnAnswer.backgroundColor=[UIColor whiteColor];
        CGFloat answerX=marginLeft+i*(answerW+margin);
        [btnAnswer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnAnswer addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btnAnswer.frame=CGRectMake(answerX, answerY, answerW, answerH);
        [self.answerView addSubview:btnAnswer];
    }

}
-(void)answerButtonClick:(UIButton *)sender{
    
     self.optionsView.userInteractionEnabled=YES;
   
    [self setAnswerButtonColor:[UIColor blackColor]];
    
    for (UIButton *optBtn in self.optionsView.subviews) {
        if(optBtn.tag==sender.tag){
            optBtn.hidden=NO;
        }
    }
     [sender setTitle:nil forState:UIControlStateNormal];
    
}

-(void)makeOptionsButtons:(Question *)model
{
    self.optionsView.userInteractionEnabled=YES;
    [self.optionsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *words=model.options;
    CGFloat margin=10;
    CGFloat answerW=35;
    CGFloat answerH=35;
    int columns=4;
    CGFloat marginLeft=(self.answerView.frame.size.width-(columns*answerW)-(columns-1)*margin)/2;
    for (int i=0; i<words.count; i++) {
        UIButton *btnOption=[[UIButton alloc]init];
        btnOption.tag=i;
        btnOption.backgroundColor=[UIColor whiteColor];
        [btnOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnOption setTitle:words[i] forState:UIControlStateNormal];
        int colIndex=i%columns;
        int rowIndex=i/columns;
        CGFloat answerX=marginLeft+colIndex*(answerW+margin);
        
        CGFloat answerY=0+rowIndex*(answerH+margin);
        btnOption.frame=CGRectMake(answerX, answerY, answerW, answerH);
        
        [btnOption addTarget:self action:@selector(optionsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionsView addSubview:btnOption];
        
    }
}
-(void)optionsButtonClick:(UIButton *) sender
{
    sender.hidden=YES;
    
    
    NSString *text=[sender titleForState:UIControlStateNormal];
    BOOL isFull=YES;
    for (UIButton *answerBTn in self.answerView.subviews) {
        if(answerBTn.currentTitle==nil)
        {
            [answerBTn setTitle:text forState:UIControlStateNormal];
            answerBTn.tag=sender.tag;
            break;
        }
    }
    NSMutableString *userInput=[[NSMutableString alloc]init];
    for (UIButton *answerBTn in self.answerView.subviews) {
        if(answerBTn.currentTitle==nil)
        {
            isFull=NO;
            break;
        }else{
            [userInput appendString:answerBTn.currentTitle];//拼接字符串
        }
    }
    if(isFull)
    {
        self.optionsView.userInteractionEnabled=NO;
        //判断答案是否正确
       Question *model= self.questions[self.index];
        if([model.answer isEqualToString:userInput])
        {
            [self addScore:100];
            [self setAnswerButtonColor:[UIColor blueColor]];
            [self performSelector:@selector(NextQuestion) withObject:nil afterDelay:0.5];
            
        }else
        {
            [self addScore:-100];
            [self setAnswerButtonColor:[UIColor redColor]];
        }
        
    }
    
}
-(void)addScore:(int)score
{
    NSString *text=self.btnScore.currentTitle;
    int curretScore=text.intValue;
    curretScore =curretScore+score;
    [self.btnScore setTitle:[NSString stringWithFormat:@"%d",curretScore] forState:UIControlStateNormal];
}

-(void)setAnswerButtonColor:(UIColor *)color
{
    for (UIButton *btnAnswer in self.answerView.subviews) {
        [btnAnswer setTitleColor:color forState:UIControlStateNormal];
    }
}
- (IBAction)btnTipClick:(id)sender {
    [self addScore:-1000];

    for (UIButton *btnAnswer in self.answerView.subviews) {
        
        [self answerButtonClick:btnAnswer];
    }
    
    Question *model=self.questions[self.index];
    NSString *firstObject=[model.answer substringFromIndex:1];
    
    for (UIButton *optBtn in self.optionsView.subviews) {
        if ([optBtn.currentTitle isEqualToString:firstObject]) {
            [self optionsButtonClick:optBtn];
            break;
        }
    }
    
    
}
@end
