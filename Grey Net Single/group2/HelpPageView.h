//
//  HelpPageView.h
//  
//
//  Created by Frank Chen on 2018/4/5.
//

#import "BaseView.h"

@interface HelpPageView : BaseView
<UITextViewDelegate>
@property (nonatomic, retain) UITextView * textView;
@end
