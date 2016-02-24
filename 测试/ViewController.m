//
//  ViewController.m
//  测试
//
//  Created by mac on 16/1/4.
//  Copyright © 2016年 王永军. All rights reserved.
//

#import "ViewController.h"




@interface  my_tableView:UITableView

@property (nonatomic , strong) UIRefreshControl * refreshControl;


@end

@implementation my_tableView


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{

    if (self = [super initWithFrame:frame style:style]) {
        
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
        
        self.refreshControl.tintColor = [UIColor grayColor];
        
        [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
        
        //改变刷新大小
        
       // [[self.subviews objectAtIndex:0] setFrame:CGRectMake(20, 0, 20, 30)];
        
        /**
         *  自定义原理
         */
        
        self.tableHeaderView  = self.refreshControl;

    }
    
    return self;

}

-(void)loadData
{

    sleep(1);
    
    
    
    
    
    //在主线程上执行一个函数
    
    [self performSelectorOnMainThread:@selector(reloadUI)
     
                           withObject:nil
     
                        waitUntilDone:NO];


}


//重新加载tableview

-(void)reloadUI

{
    
    NSAttributedString * string=[[NSAttributedString alloc]
                                  initWithString:@"下拉可刷新"]
                                 ;
    
    self.refreshControl.attributedTitle=string;
    
    [self.refreshControl endRefreshing];
    
    [self reloadData];
    
}

-(void)RefreshViewControlEventValueChanged{
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
    
}


@end


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property ( strong , nonatomic ) my_tableView * my_tableView;

@property ( nonatomic , strong ) NSMutableArray *dataArray;

@property ( assign ) BOOL isOpen;



@end


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildUI];
    
    [self source];

}



-(void)buildUI
{
    [self.view addSubview:self.my_tableView];
    
}

-(void)source
{

    NSDictionary *dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( NO )} ;
    
    NSArray * array = @[ dic,dic,dic,dic,dic,dic,dic,dic,dic,dic,dic,dic ] ;
    
    self . dataArray = [[ NSMutableArray alloc ] init ];
    
    self . dataArray = [ NSMutableArray arrayWithArray :array];
    
 

}

-(my_tableView *)my_tableView
{
    if (!_my_tableView) {
        
        _my_tableView = [[my_tableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain ];
        
        _my_tableView.delegate = self;
        
        _my_tableView.dataSource = self;
        
        _my_tableView.tableFooterView = [[UIView alloc]init];

    }
    return _my_tableView;

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- ( NSInteger )tableView:( UITableView *)tableView numberOfRowsInSection:( NSInteger )section

{
    
    // Return the number of rows in the section.
    
    return self . dataArray . count ;;
    
}

- ( NSInteger )numberOfSectionsInTableView:( UITableView *)tableView

{
    
    // Return the number of sections.
    
    return 1 ;
    
}

// tableViewCell

-( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath

{
    
    if ([[ self . dataArray [indexPath. row ] objectForKey : @"Cell" ] isEqualToString : @"MainCell" ])
        
    {
        
        static NSString *CellIdentifier = @"MainCell" ;
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier :CellIdentifier];
        
        if (cell == nil ) {
            
            cell = [[ UITableViewCell alloc ] initWithStyle : UITableViewCellStyleDefault reuseIdentifier :CellIdentifier];
            
            cell. selectionStyle = UITableViewCellSelectionStyleGray ;
            
        }
        
        cell.textLabel.text = @"cell";
        
        UIImageView * accessoryImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        
        //[self ImageViewImageName:@"common_icon_arrow" frame:CGRectMake(0, 0, 14, 20)];
        
        cell.accessoryView = accessoryImage;
        
        //    cell.Headerphoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",indexPath.row%4+1]];
        
        return cell;
        
    } else if ([[ self . dataArray [indexPath. row ] objectForKey : @"Cell" ] isEqualToString : @"AttachedCell" ]){
        
        static NSString *CellIdentifier = @"AttachedCell" ;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier :CellIdentifier];
        
        
        if (cell == nil ) {
            
            cell = [[ UITableViewCell alloc ] initWithStyle : UITableViewCellStyleSubtitle reuseIdentifier :CellIdentifier];
            
            cell. selectionStyle = UITableViewCellSelectionStyleNone ;
            
        }
        
        cell.textLabel.text = @"副标题";
        
        cell.detailTextLabel.text = @"detailcell";
        
        return cell;
        
    }
    
    return nil ;
    
}

// tableView 点击事件

-( void )tableView:( UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath :indexPath animated : YES ];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSIndexPath *path = nil ;
    
    if ([[ self . dataArray [indexPath. row ] objectForKey : @"Cell" ] isEqualToString : @"MainCell" ]) {
        
        path = [ NSIndexPath indexPathForItem :(indexPath. row + 1 ) inSection :indexPath. section ];
        
    } else {
        
        path = indexPath;
        
    }
    
    if ([[ self . dataArray [indexPath. row ] objectForKey : @"isAttached" ] boolValue ]) {
        
        // 关闭附加 cell
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.accessoryView.transform=CGAffineTransformMakeRotation(M_PI*2);

        }];
        
        
        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( NO )} ;
        
        self . dataArray [(path. row - 1 )] = dic;
        
        [ self . dataArray removeObjectAtIndex :path. row ];
        
        [ self . my_tableView beginUpdates ];
        
        [ self . my_tableView deleteRowsAtIndexPaths : @[ path ]   withRowAnimation : UITableViewRowAnimationMiddle ];
        
        [ self . my_tableView endUpdates ];
        
    } else {
        
        // 打开附加 cell
        
        [UIView animateWithDuration:0.2 animations:^{
            
            cell.accessoryView.transform=CGAffineTransformMakeRotation(M_PI*0.5);
        }];
    
        
        NSDictionary * dic = @{ @"Cell" : @"MainCell" , @"isAttached" : @( YES )} ;
        
        self . dataArray [(path. row - 1 )] = dic;
        
        NSDictionary * addDic = @{ @"Cell" : @"AttachedCell" , @"isAttached" : @( YES )} ;
        
        [ self . dataArray insertObject :addDic atIndex :path. row ];
        
        [ self . my_tableView beginUpdates ];
        
        [ self . my_tableView insertRowsAtIndexPaths : @[ path ] withRowAnimation : UITableViewRowAnimationMiddle ];
        
        [ self . my_tableView endUpdates ];
        
    }
    
}


- (UIImageView *)ImageViewImageName:(NSString*)aImageName frame:(CGRect)aRect{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:aRect];
    
    imageView.userInteractionEnabled = YES;
    
    UIImage *aImage = [UIImage imageNamed:(aImageName)];
    
    if ([aImage respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        
        imageView.image = [aImage resizableImageWithCapInsets:UIEdgeInsetsMake(aImage.size.height/2, aImage.size.width/2, aImage.size.height/2, aImage.size.width/2)];
    } else {
        imageView.image = [aImage stretchableImageWithLeftCapWidth:aImage.size.width/2 topCapHeight:aImage.size.height/2];
    }
    return imageView;
}















@end
