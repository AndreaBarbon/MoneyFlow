/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#define max_text_height 50
#define max_text_width 190


#import "PCPieChart.h"

@implementation PCPieComponent
@synthesize value, title, colour, startDeg, endDeg;

- (id)initWithTitle:(NSString*)_title value:(float)_value
{
    self = [super init];
    if (self)
    {
        self.title = _title;
        self.value = _value;
        self.colour = PCColorDefault;
    }
    return self;
}

+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value
{
    return [[[super alloc] initWithTitle:_title value:_value] autorelease];
}

- (NSString*)description
{
    NSMutableString *text = [NSMutableString string];
    [text appendFormat:@"title: %@\n", self.title];
    [text appendFormat:@"value: %f\n", self.value];
    return text;
}

- (void)dealloc
{
    [colour release];
    [title release];
    [super dealloc];
}

@end

@implementation PCPieChart
@synthesize components;
@synthesize diameter;
@synthesize titleFont, percentageFont;
@synthesize showArrow, sameColorLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
		
		self.titleFont = [UIFont fontWithName:@"GeezaPro" size:10];//[UIFont boldSystemFontOfSize:20];
		self.percentageFont = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];//[UIFont boldSystemFontOfSize:14];
		self.showArrow = YES;
		self.sameColorLabel = NO;
		
	}
    return self;
}

#define LABEL_TOP_MARGIN 15
#define ARROW_HEAD_LENGTH 6
#define ARROW_HEAD_WIDTH 4

#define PIE_DIAMETER 500


- (void)drawRect:(CGRect)rect
{
    // Drawing code

    //float margin = 130;
    float shift_x = 100;
    
    
    diameter = PIE_DIAMETER;

    //diameter = MIN(rect.size.width, rect.size.height) - 2*margin;
    
    
    float x = shift_x + (rect.size.width - diameter)/2;
    float y = 20;
    float gap = 1.5;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    //NSLog(@"Diameter = %d", self.diameter);

    
    // label stuff
    float left_label_y = LABEL_TOP_MARGIN;
    //float right_label_y = LABEL_TOP_MARGIN;
    
    
    if ([components count]>0)
    {
        
        float total = 0;
        for (PCPieComponent *component in components)
        {
            total += component.value;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
		UIGraphicsPushContext(ctx);
		CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
		//CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin/2);
        CGContextSetShadowWithColor(ctx, CGSizeMake(10.0f, 10.0f), 10, [[UIColor lightGrayColor] CGColor]);
		CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
		UIGraphicsPopContext();
		CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
		
        
        
        
		float nextStartDeg = 0;
		float endDeg = 0;
		NSMutableArray *tmpComponents = [NSMutableArray array];
		int last_insert = -1;
		for (int i=0; i<[components count]; i++)
		{
			PCPieComponent *component  = [components objectAtIndex:i];
			float perc = [component value]/total;
			endDeg = nextStartDeg+perc*360;
			
			CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextFillPath(ctx);
			
            CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.3);
            //CGContextSetStrokeColorWithColor(ctx, [AZZURRO CGColor]);

			CGContextSetLineWidth(ctx, gap);
			CGContextMoveToPoint(ctx, origin_x, origin_y);
			CGContextAddArc(ctx, origin_x, origin_y, inner_radius, (nextStartDeg-90)*M_PI/180.0, (endDeg-90)*M_PI/180.0, 0);
			CGContextClosePath(ctx);
			CGContextStrokePath(ctx);
			
			[component setStartDeg:nextStartDeg];
			[component setEndDeg:endDeg];
            
            //Rearranges components: deactivated
			if (nextStartDeg<180)
			{
				[tmpComponents addObject:component];
			}
			else
			{
				if (last_insert==-1)
				{
					last_insert = i;
					[tmpComponents addObject:component];
				}
				else
				{
					[tmpComponents insertObject:component atIndex:last_insert];
				}
			}
			
			nextStartDeg = endDeg;
		}
		
		nextStartDeg = 0;
		endDeg = 0;
        
        
        
		for (PCPieComponent *component in components)
		{
			nextStartDeg = component.startDeg;
			endDeg = component.endDeg;
			
			if (TRUE)//(nextStartDeg > 180 ||  (nextStartDeg < 180 && endDeg> 270) )
			{
// left
				
				// display percentage label
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 1);
				
				//float text_x = x + 10;
				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,max_text_height)];
				CGRect percFrame = CGRectMake(5, left_label_y,  max_text_width, optimumSize.height);
				[percentageText drawInRect:percFrame withFont:self.percentageFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
				
				if (self.showArrow)
				{
					// draw line to point to chart
					CGContextSetRGBStrokeColor(ctx, 0.8f, 0.8f, 0.8f, 1);
					CGContextSetRGBFillColor(ctx, 0.8f, 0.8f, 0.8f, 1);
					
					
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
					CGContextSetLineWidth(ctx, 1);
					if (left_label_y + optimumSize.height/2 < y)//(left_label_y==LABEL_TOP_MARGIN)
					{
						
						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
						//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
						CGContextClosePath(ctx);
						CGContextFillPath(ctx);
						
					}
					else
					{
						
						CGContextMoveToPoint(ctx, 5 + max_text_width, left_label_y + optimumSize.height/2);
						if (left_label_y + optimumSize.height/2 > y + diameter)
						{
							CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
							CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
						else
						{
							float y_diff = y1 - (left_label_y + optimumSize.height/2);
							if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
							{
								
								// straight arrow
								y1 = left_label_y + optimumSize.height/2;
								
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_LENGTH, y1);
								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							}
							else if (left_label_y + optimumSize.height/2<y1)
							{
								// arrow point down
								
								y1 -= ARROW_HEAD_LENGTH;
								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
								CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							} 
							else
							{
								// arrow point up
								
								y1 += ARROW_HEAD_LENGTH;
								CGContextAddLineToPoint(ctx, x1, left_label_y + optimumSize.height/2);
								CGContextAddLineToPoint(ctx, x1, y1);
								CGContextStrokePath(ctx);
								
								//CGContextSetRGBFillColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);
								CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
								CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
								CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
								CGContextClosePath(ctx);
								CGContextFillPath(ctx);
							}
						}
					}
					
				}
                
// display title on the left
                NSString *title = [NSString stringWithFormat:@"%@: %.0f€", component.title, component.value];
				CGContextSetFillColorWithColor(ctx, [AZZURRO CGColor]);
				left_label_y += optimumSize.height - 4;
				optimumSize = [title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,max_text_height)];
				CGRect titleFrame = CGRectMake(5, left_label_y, max_text_width, optimumSize.height);
				[title drawInRect:titleFrame withFont:self.titleFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentRight];
                //NSLog(@"Title: %@", title);
				left_label_y += optimumSize.height + 10;
			}
            /*
			else 
			{
// right
				
				// display percentage label
				if (self.sameColorLabel)
				{
					CGContextSetFillColorWithColor(ctx, [component.colour CGColor]);
				}
				else 
				{
					CGContextSetRGBFillColor(ctx, 0.1f, 0.1f, 0.1f, 1.0f);
				}
				CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 2);
				
				float text_x = x + diameter + 10;
				NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", component.value/total*100];
				CGSize optimumSize = [percentageText sizeWithFont:self.percentageFont constrainedToSize:CGSizeMake(max_text_width,max_text_height)];
				CGRect percFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
				[percentageText drawInRect:percFrame withFont:self.percentageFont];
				
				if (self.showArrow)
				{
					// draw line to point to chart
					CGContextSetRGBStrokeColor(ctx, 0.8f, 0.8f, 0.8f, 1);
					CGContextSetRGBFillColor(ctx, 0.8f, 0.8f, 0.8f, 1);
					
					CGContextSetLineWidth(ctx, 1);
					int x1 = inner_radius/4*3*cos((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_x; 
					int y1 = inner_radius/4*3*sin((nextStartDeg+component.value/total*360/2-90)*M_PI/180.0)+origin_y;
					
					
					if (right_label_y + optimumSize.height/2 < y)//(right_label_y==LABEL_TOP_MARGIN)
					{
						
						CGContextMoveToPoint(ctx, text_x - 3, right_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
						CGContextAddLineToPoint(ctx, x1, y1);
						CGContextStrokePath(ctx);
						
						CGContextMoveToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
						CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
						CGContextAddLineToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
						CGContextClosePath(ctx);
						CGContextFillPath(ctx);
					}
					else
					{
						float y_diff = y1 - (right_label_y + optimumSize.height/2);
						if ( (y_diff < 2*ARROW_HEAD_LENGTH && y_diff>0) || (-1*y_diff < 2*ARROW_HEAD_LENGTH && y_diff<0))
						{
							// straight arrow
							y1 = right_label_y + optimumSize.height/2;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							CGContextMoveToPoint(ctx, x1, y1-ARROW_HEAD_WIDTH/2);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_LENGTH, y1);
							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_WIDTH/2);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
						else if (right_label_y + optimumSize.height/2<y1)
						{
							// arrow point down
							
							y1 -= ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx); 
							
							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1+ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						} 
						else //if (nextStartDeg<180 && endDeg>180)
						{
							// arrow point up
							y1 += ARROW_HEAD_LENGTH;
							
							CGContextMoveToPoint(ctx, text_x, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, right_label_y + optimumSize.height/2);
							CGContextAddLineToPoint(ctx, x1, y1);
							CGContextStrokePath(ctx);
							
							CGContextMoveToPoint(ctx, x1+ARROW_HEAD_WIDTH/2, y1);
							CGContextAddLineToPoint(ctx, x1, y1-ARROW_HEAD_LENGTH);
							CGContextAddLineToPoint(ctx, x1-ARROW_HEAD_WIDTH/2, y1);
							CGContextClosePath(ctx);
							CGContextFillPath(ctx);
						}
					}
				}
				
				// display title on the left
				CGContextSetRGBFillColor(ctx, 0.4f, 0.4f, 0.4f, 1.0f);
				right_label_y += optimumSize.height - 4;
				optimumSize = [component.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(max_text_width,max_text_height)];
				CGRect titleFrame = CGRectMake(text_x, right_label_y, optimumSize.width, optimumSize.height);
				[component.title drawInRect:titleFrame withFont:self.titleFont];
				right_label_y += optimumSize.height + 10;
			}
            */
			
			
			nextStartDeg = endDeg;
		}
    }
	
	
}

- (void)dealloc
{
	[self.titleFont release];
	[self.percentageFont release];
    [self.components release];
    [super dealloc];
}


@end
