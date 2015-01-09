# SYActionSheetView

* SYActionSheetView实现了类似于UIActionSheet的效果，简单易用，完美支持IOS5.0及以上版本。

用法：

* SYActionSheetView *actv = [[SYActionSheetView alloc] initWithTitle:nil cancelButtonTitle:@"cancle"      
* otherButtonTitles:@"action1",@"action2",nil];
* actv.syActionSheetActionBlock = ^(UIButton *actionBtn){
        
        if (actionBtn.tag == kBtnCaccleTag + 1)
        {
            SYLog(@"%@",actionBtn.titleLabel.text);
        }
        else if (actionBtn.tag == kBtnCaccleTag + 2)
        {
            SYLog(@"%@",actionBtn.titleLabel.text);
        }
    };
*    [actv showSYActionSheet];

