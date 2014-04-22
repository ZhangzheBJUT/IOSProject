//***********************************************************
//  GASSDrawTools.m
//  GASSNotepad
//
//  Created by zhangzhe on 13-6-25.
//  Copyright (c) 2013年 com.test. All rights reserved.
//**********************************************************/

#import "GASSDrawTools.h"
#import "GASSNotepadView.h"

@interface GASSDrawTools()

@property (nonatomic,assign) CGContextRef contextRef;      //图形上下文
@property (nonatomic,assign) float   defaultStrokeWidth;   //线条的宽度

@end

@implementation GASSDrawTools

@synthesize defaultStrokeWidth;
@synthesize strokeColor;
@synthesize strokeWidth;


//*********************************************************
//
// 函数描述：
//        初始化函数
//
//*******************************************************/
- (id) init
{
    if (self = [super init])
    {
        _contextRef = NULL;
        self.defaultStrokeWidth = 4.0f;
        self.strokeColor = [UIColor redColor];
        self.strokeWidth = defaultStrokeWidth;
    }
    return self;
}

- (CGRect)drawLineFrom : (CGPoint)aStart
				 andTo : (CGPoint)aEnd
{
    return CGRectMake(0, 0, 0, 0);
}
- (CGFloat) getSlopeWithFrom:(CGPoint)aStart
                       andTo:(CGPoint)aEnd
{
    if (aStart.x == aEnd.x || aStart.y == aEnd.y)
	{
		return 0;
	}
    
	return (aStart.x - aEnd.x) / (aStart.y - aEnd.y);
}
//*********************************************************
//
// 函数描述：
//        绘制线条
//
//*******************************************************/
- (CGRect)getLineRectFrom:(CGPoint)aStart
                    andTo:(CGPoint)aEnd
{
    CGFloat width  = abs(aStart.x-aEnd.x);
    CGFloat height = abs(aStart.y-aEnd.y);
    
    CGFloat x = aStart.x;
    CGFloat y = aStart.y;
    
    //CGFloat slope = [self getSlopeWithFrom:aStart andTo:aEnd];
    
    if (aStart.x>aEnd.x)
    {
        x = aEnd.x-self.strokeWidth/2;
    }
    else
    {
        x = aStart.x-self.strokeWidth/2;
    }
    
    if (aStart.y>aEnd.y)
    {
        y = aEnd.y - self.strokeWidth/2;
    }
    else
    {
        y = aStart.y - self.strokeWidth/2;
    }

    return CGRectMake(x, y, width+self.strokeWidth, height+self.strokeWidth);
}

//*********************************************************
//
// 函数描述：
//        绘制线条
//
//*******************************************************/
- (CGRect)strokeView : (UIView *)aStrokeView
		    drawFrom : (CGPoint)aFrom
			   andTo : (CGPoint)aTo
{
    //*****************取得所绘图形的图形上下文***********
    GASSNotepadView *notepadView = (GASSNotepadView*)aStrokeView;
    _contextRef = notepadView.layerContextRef;
    
    //******************设置颜色**********************

  	CGColorRef color = self.strokeColor.CGColor;
	const CGFloat *components = CGColorGetComponents(color);
	CGContextSetRGBStrokeColor(_contextRef, components[0], components[1],
							              components[2], components[3]);
    
	//******************设置笔宽*********************
    CGContextSetLineWidth(_contextRef, self.strokeWidth);

    //******************画线*************************
    CGContextMoveToPoint(_contextRef, aFrom.x, aFrom.y);
    CGContextAddLineToPoint(_contextRef, aTo.x,aTo.y);
    
	CGContextStrokePath(_contextRef);
    
    CGRect rect  = [self getLineRectFrom:aFrom andTo:aTo];
    return rect;

}
//*********************************************************
//
// 函数描述：
//        绘制图片
//
//*******************************************************/
- (void)strokeView : (UIView*)aStrokeView
         drawImage : (UIImage *)aImage
{
    GASSNotepadView *notepadView = (GASSNotepadView*)aStrokeView;
    _contextRef  = notepadView.layerContextRef;
    
    CGContextSaveGState(_contextRef);
        
    CGContextTranslateCTM(_contextRef, 0, aImage.size.height);
    CGContextScaleCTM(_contextRef, 1.0, -1.0);
    
    CGContextDrawImage(_contextRef,CGRectMake(0, 0,aImage.size.height, aImage.size.width),aImage.CGImage);
    
    
    CGContextRestoreGState(_contextRef);
    
}
@end
