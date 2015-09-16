//
//  NoteTextView.swift
//  NotePadApp
//
//  Created by SAALIS UMER on 08/09/15.
//  Copyright (c) 2015 SAALIS UMER. All rights reserved.
//

import UIKit

class NoteTextView: UITextView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
 
            //Get the current drawing context
            var context :CGContextRef = UIGraphicsGetCurrentContext();
            //Set the line color and width
            CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor);
            CGContextSetLineWidth(context, 1.0);
            //Start a new Path
            CGContextBeginPath(context);
            
            //Find the number of lines in our textView + add a bit more height to draw lines in the empty part of the view
            var numberOfLines:Int = Int((self.contentSize.height + self.bounds.size.height) / self.font.leading);
            
            //Set the line offset from the baseline. (I'm sure there's a concrete way to calculate this.)
        var baselineOffset:CGFloat = 6.0;
            
            //iterate over numberOfLines and draw each line
        var x:Int
        for x = 1; x < numberOfLines; x++ {                       //0.5f offset lines up line with pixel boundary
            var float1:CGFloat = 0.5
            var float2 = CGFloat(self.font.leading)*CGFloat(x) + CGFloat(float1) + CGFloat(baselineOffset)

                CGContextMoveToPoint(context, self.bounds.origin.x + 10,float2 );
                CGContextAddLineToPoint(context, CGFloat(self.bounds.size.width) - CGFloat(10), CGFloat(self.font.leading)*CGFloat(x) + float1 + CGFloat(baselineOffset));
            }
            
            //Close our Path and Stroke (draw) it
            CGContextClosePath(context);
            CGContextStrokePath(context);
        }
}
