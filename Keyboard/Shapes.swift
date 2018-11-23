//
//  Shapes.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

// TODO: these shapes were traced and as such are erratic and inaccurate; should redo as SVG or PDF

///////////////////
// SHAPE OBJECTS //
///////////////////

class BackspaceShape: Shape {
    override func drawCall(_ color: UIColor) {
		drawBackspace(bounds: self.bounds, color: color)
    }
}

class ShiftShape: Shape {
    var withLock: Bool = false {
        didSet {
            self.overflowCanvas.setNeedsDisplay()
        }
    }
    
    override func drawCall(_ color: UIColor) {
        drawShift(self.bounds, color: color, withRect: self.withLock)
    }
}

class GlobeShape: Shape {
    override func drawCall(_ color: UIColor) {
		drawGlobe(bounds: self.bounds, color: color)
    }
}

//
class ReturnShape: Shape {
	override func drawCall(_ color: UIColor) {
		drawReturn(bounds: self.bounds, color: color)
	}
}
//

class Shape: UIView {
    var color: UIColor? {
        didSet {
            if let _ = self.color {
                self.overflowCanvas.setNeedsDisplay()
            }
        }
    }
    
    // in case shapes draw out of bounds, we still want them to show
    var overflowCanvas: OverflowCanvas!
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isOpaque = false
        self.clipsToBounds = false
        
        self.overflowCanvas = OverflowCanvas(shape: self)
        self.addSubview(self.overflowCanvas)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var oldBounds: CGRect?
    override func layoutSubviews() {
        if self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        if oldBounds != nil && self.bounds.equalTo(oldBounds!) {
            return
        }
        oldBounds = self.bounds
        
        super.layoutSubviews()
        
        let overflowCanvasSizeRatio = CGFloat(1.25)
        let overflowCanvasSize = CGSize(width: self.bounds.width * overflowCanvasSizeRatio, height: self.bounds.height * overflowCanvasSizeRatio)
        
        self.overflowCanvas.frame = CGRect(
            x: CGFloat((self.bounds.width - overflowCanvasSize.width) / 2.0),
            y: CGFloat((self.bounds.height - overflowCanvasSize.height) / 2.0),
            width: overflowCanvasSize.width,
            height: overflowCanvasSize.height)
        self.overflowCanvas.setNeedsDisplay()
    }
    
    func drawCall(_ color: UIColor) { /* override me! */ }
    
    class OverflowCanvas: UIView {
        unowned var shape: Shape
        
        init(shape: Shape) {
            self.shape = shape
            
            super.init(frame: CGRect.zero)
            
            self.isOpaque = false
        }

        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func draw(_ rect: CGRect) {
            let ctx = UIGraphicsGetCurrentContext()
            CGColorSpaceCreateDeviceRGB()
            
            ctx?.saveGState()
            
            let xOffset = (self.bounds.width - self.shape.bounds.width) / CGFloat(2)
            let yOffset = (self.bounds.height - self.shape.bounds.height) / CGFloat(2)
            ctx?.translateBy(x: xOffset, y: yOffset)
            
            self.shape.drawCall(shape.color != nil ? shape.color! : UIColor.black)
            
            ctx?.restoreGState()
        }
    }
}

/////////////////////
// SHAPE FUNCTIONS //
/////////////////////

func getFactors(_ fromSize: CGSize, toRect: CGRect) -> (xScalingFactor: CGFloat, yScalingFactor: CGFloat, lineWidthScalingFactor: CGFloat, fillIsHorizontal: Bool, offset: CGFloat) {
    
    let xSize = { () -> CGFloat in
        let scaledSize = (fromSize.width / CGFloat(2))
        if scaledSize > toRect.width {
            return (toRect.width / scaledSize) / CGFloat(2)
        }
        else {
            return CGFloat(0.5)
        }
    }()
    
    let ySize = { () -> CGFloat in
        let scaledSize = (fromSize.height / CGFloat(2))
        if scaledSize > toRect.height {
            return (toRect.height / scaledSize) / CGFloat(2)
        }
        else {
            return CGFloat(0.5)
        }
    }()
    
    let actualSize = min(xSize, ySize)
    
    return (actualSize, actualSize, actualSize, false, 0)
}

func centerShape(_ fromSize: CGSize, toRect: CGRect) {
    let xOffset = (toRect.width - fromSize.width) / CGFloat(2)
    let yOffset = (toRect.height - fromSize.height) / CGFloat(2)
    
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.saveGState()
    ctx?.translateBy(x: xOffset, y: yOffset)
}

func endCenter() {
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.restoreGState()
}

//
func drawBackspace(bounds: CGRect, color: UIColor) {
	let factors = getFactors(CGSize.init(width:46, height:34), toRect: bounds)
	let xScalingFactor = factors.xScalingFactor
	let yScalingFactor = factors.yScalingFactor
	_ = factors.lineWidthScalingFactor

	centerShape(CGSize.init(width:46 * xScalingFactor, height:34 * yScalingFactor), toRect: bounds)

	//// General Declarations
	let context = UIGraphicsGetCurrentContext()

	//// Group
	context!.saveGState()
	context!.translateBy(x: 1, y: 0.5)
	context!.scaleBy(x: 0.5, y: 0.5)

	//// Color Declarations
	let color = color
	//let color2 = UIColor.grayColor() // TODO:




	//// Bezier 3 Drawing
	let bezier3Path = UIBezierPath()
	bezier3Path.move(to: CGPoint.init(x: 18.28, y: 1.5))
	bezier3Path.addLine(to: CGPoint.init(x: 7.79, y: 1.5))
	bezier3Path.addLine(to: CGPoint.init(x: 5.12, y: 1.8))
	bezier3Path.addCurve(to: CGPoint.init(x: 3.5, y: 2.57), controlPoint1: CGPoint.init(x: 5.12, y: 1.8), controlPoint2: CGPoint.init(x: 3.85, y: 2.19))
	bezier3Path.addCurve(to: CGPoint.init(x: 2.5, y: 3.64), controlPoint1: CGPoint.init(x: 2.91, y: 3.22), controlPoint2: CGPoint.init(x: 2.9, y: 3.2))
	bezier3Path.addCurve(to: CGPoint.init(x: 1.5, y: 5.78), controlPoint1: CGPoint.init(x: 1.87, y: 4.32), controlPoint2: CGPoint.init(x: 1.5, y: 5.78))
	bezier3Path.addLine(to: CGPoint.init(x: 1.5, y: 7.91))
	bezier3Path.addLine(to: CGPoint.init(x: 1.5, y: 26.09))
	bezier3Path.addLine(to: CGPoint.init(x: 1.5, y: 28.22))
	bezier3Path.addCurve(to: CGPoint.init(x: 2.5, y: 30.36), controlPoint1: CGPoint.init(x: 1.5, y: 28.22), controlPoint2: CGPoint.init(x: 1.97, y: 29.49))
	bezier3Path.addCurve(to: CGPoint.init(x: 3.5, y: 31.43), controlPoint1: CGPoint.init(x: 2.87, y: 30.99), controlPoint2: CGPoint.init(x: 3.3, y: 31.26))
	bezier3Path.addCurve(to: CGPoint.init(x: 5.07, y: 32.18), controlPoint1: CGPoint.init(x: 3.91, y: 31.78), controlPoint2: CGPoint.init(x: 5.07, y: 32.18))
	bezier3Path.addLine(to: CGPoint.init(x: 7.5, y: 32.5))
	bezier3Path.addLine(to: CGPoint.init(x: 27.72, y: 32.5))
	bezier3Path.addLine(to: CGPoint.init(x: 30.01, y: 31.87))
	bezier3Path.addLine(to: CGPoint.init(x: 30.87, y: 31.43))
	bezier3Path.addLine(to: CGPoint.init(x: 32.24, y: 30.03))
	bezier3Path.addLine(to: CGPoint.init(x: 33.5, y: 28.75))
	bezier3Path.addLine(to: CGPoint.init(x: 44.5, y: 17.53))
	bezier3Path.addLine(to: CGPoint.init(x: 44.5, y: 16.47))
	bezier3Path.addLine(to: CGPoint.init(x: 33.55, y: 5.3))
	bezier3Path.addLine(to: CGPoint.init(x: 32.33, y: 4.06))
	bezier3Path.addLine(to: CGPoint.init(x: 30.87, y: 2.57))
	bezier3Path.addLine(to: CGPoint.init(x: 30.02, y: 2.14))
	bezier3Path.addLine(to: CGPoint.init(x: 27.72, y: 1.5))
	bezier3Path.addLine(to: CGPoint.init(x: 18.28, y: 1.5))
	color.setStroke()
	bezier3Path.lineWidth = 3
	bezier3Path.stroke()


	//// Group
	//// Bezier Drawing
	let bezierPath = UIBezierPath()
	bezierPath.move(to: CGPoint.init(x: 12.5, y: 10.5))
	bezierPath.addCurve(to: CGPoint.init(x: 25, y: 23), controlPoint1: CGPoint.init(x: 25, y: 23), controlPoint2: CGPoint.init(x: 25, y: 23))
	bezierPath.lineCapStyle = .round;

	bezierPath.lineJoinStyle = .round;

	color.setStroke()
	bezierPath.lineWidth = 3
	bezierPath.stroke()


	//// Bezier 2 Drawing
	let bezier2Path = UIBezierPath()
	bezier2Path.move(to: CGPoint.init(x: 25, y: 10.5))
	bezier2Path.addCurve(to: CGPoint.init(x: 12.5, y: 23), controlPoint1: CGPoint.init(x: 12.5, y: 23), controlPoint2: CGPoint.init(x: 12.5, y: 23))
	bezier2Path.lineCapStyle = .round;

	bezier2Path.lineJoinStyle = .round;

	color.setStroke()
	bezier2Path.lineWidth = 3
	bezier2Path.stroke()

	context!.restoreGState()


	endCenter()
}
//

//func drawBackspace(_ bounds: CGRect, color: UIColor) {
//    let factors = getFactors(CGSize(width: 44, height: 32), toRect: bounds)
//    let xScalingFactor = factors.xScalingFactor
//    let yScalingFactor = factors.yScalingFactor
//    let lineWidthScalingFactor = factors.lineWidthScalingFactor
//
//    centerShape(CGSize(width: 44 * xScalingFactor, height: 32 * yScalingFactor), toRect: bounds)
//
//
//    //// Color Declarations
//    let color = color
//    let color2 = UIColor.gray // TODO:
//
//    //// Bezier Drawing
//    let bezierPath = UIBezierPath()
//    bezierPath.move(to: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor))
//    bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 32 * yScalingFactor))
//    bezierPath.addCurve(to: CGPoint(x: 44 * xScalingFactor, y: 26 * yScalingFactor), controlPoint1: CGPoint(x: 38 * xScalingFactor, y: 32 * yScalingFactor), controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 32 * yScalingFactor))
//    bezierPath.addCurve(to: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor), controlPoint1: CGPoint(x: 44 * xScalingFactor, y: 22 * yScalingFactor), controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor))
//    bezierPath.addCurve(to: CGPoint(x: 36 * xScalingFactor, y: 0 * yScalingFactor), controlPoint1: CGPoint(x: 44 * xScalingFactor, y: 6 * yScalingFactor), controlPoint2: CGPoint(x: 44 * xScalingFactor, y: 0 * yScalingFactor))
//    bezierPath.addCurve(to: CGPoint(x: 16 * xScalingFactor, y: 0 * yScalingFactor), controlPoint1: CGPoint(x: 32 * xScalingFactor, y: 0 * yScalingFactor), controlPoint2: CGPoint(x: 16 * xScalingFactor, y: 0 * yScalingFactor))
//    bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
//    bezierPath.addLine(to: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor))
//    bezierPath.close()
//    color.setFill()
//    bezierPath.fill()
//
//
//    //// Bezier 2 Drawing
//    let bezier2Path = UIBezierPath()
//    bezier2Path.move(to: CGPoint(x: 20 * xScalingFactor, y: 10 * yScalingFactor))
//    bezier2Path.addLine(to: CGPoint(x: 34 * xScalingFactor, y: 22 * yScalingFactor))
//    bezier2Path.addLine(to: CGPoint(x: 20 * xScalingFactor, y: 10 * yScalingFactor))
//    bezier2Path.close()
//    UIColor.gray.setFill()
//    bezier2Path.fill()
//    color2.setStroke()
//    bezier2Path.lineWidth = 2.5 * lineWidthScalingFactor
//    bezier2Path.stroke()
//
//
//    //// Bezier 3 Drawing
//    let bezier3Path = UIBezierPath()
//    bezier3Path.move(to: CGPoint(x: 20 * xScalingFactor, y: 22 * yScalingFactor))
//    bezier3Path.addLine(to: CGPoint(x: 34 * xScalingFactor, y: 10 * yScalingFactor))
//    bezier3Path.addLine(to: CGPoint(x: 20 * xScalingFactor, y: 22 * yScalingFactor))
//    bezier3Path.close()
//    UIColor.red.setFill()
//    bezier3Path.fill()
//    color2.setStroke()
//    bezier3Path.lineWidth = 2.5 * lineWidthScalingFactor
//    bezier3Path.stroke()
//
//    endCenter()
//}

func drawShift(_ bounds: CGRect, color: UIColor, withRect: Bool) {
    let factors = getFactors(CGSize(width: 38, height: (withRect ? 34 + 4 : 32)), toRect: bounds)
    let xScalingFactor = factors.xScalingFactor
    let yScalingFactor = factors.yScalingFactor
    _ = factors.lineWidthScalingFactor
    
    centerShape(CGSize(width: 38 * xScalingFactor, height: (withRect ? 34 + 4 : 32) * yScalingFactor), toRect: bounds)
    
    
    //// Color Declarations
    let color2 = color
    
    //// Bezier Drawing
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 38 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 19 * xScalingFactor, y: 0 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 0 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.addLine(to: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor))
    bezierPath.addCurve(to: CGPoint(x: 14 * xScalingFactor, y: 32 * yScalingFactor), controlPoint1: CGPoint(x: 10 * xScalingFactor, y: 28 * yScalingFactor), controlPoint2: CGPoint(x: 10 * xScalingFactor, y: 32 * yScalingFactor))
    bezierPath.addCurve(to: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor), controlPoint1: CGPoint(x: 16 * xScalingFactor, y: 32 * yScalingFactor), controlPoint2: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor))
    bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 28 * yScalingFactor), controlPoint1: CGPoint(x: 24 * xScalingFactor, y: 32 * yScalingFactor), controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 32 * yScalingFactor))
    bezierPath.addCurve(to: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor), controlPoint1: CGPoint(x: 28 * xScalingFactor, y: 26 * yScalingFactor), controlPoint2: CGPoint(x: 28 * xScalingFactor, y: 18 * yScalingFactor))
    bezierPath.close()
    color2.setFill()
    bezierPath.fill()
    
    
    if withRect {
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 10 * xScalingFactor, y: 34 * yScalingFactor, width: 18 * xScalingFactor, height: 4 * yScalingFactor))
        color2.setFill()
        rectanglePath.fill()
    }
    
    endCenter()
}

func drawGlobe(bounds: CGRect, color: UIColor) {
	let factors = getFactors(CGSize.init(width: 41, height: 40), toRect: bounds)
	let xScalingFactor = factors.xScalingFactor
	let yScalingFactor = factors.yScalingFactor
	let lineWidthScalingFactor = factors.lineWidthScalingFactor

	centerShape(CGSize.init(width: 41 * xScalingFactor, height: 40 * yScalingFactor), toRect: bounds)

	//// General Declarations
	let context = UIGraphicsGetCurrentContext()

	//// Group
	context!.saveGState()
	context!.translateBy(x: 1, y: 0.92)
	context!.scaleBy(x: 0.92, y: 0.92)

	//// Color Declarations
	let color = color

	//// Oval Drawing
	let ovalPath = UIBezierPath(ovalIn: CGRect.init(x: 0 * xScalingFactor, y: 0 * yScalingFactor, width: 40 * xScalingFactor, height: 40 * yScalingFactor))
	color.setStroke()
	ovalPath.lineWidth = 2.0 * lineWidthScalingFactor
	ovalPath.stroke()


	//// Bezier Drawing
	let bezierPath = UIBezierPath()
	bezierPath.move(to: CGPoint.init(x: 20 * xScalingFactor, y: -0 * yScalingFactor))
	bezierPath.addLine(to: CGPoint.init(x: 20 * xScalingFactor, y: 40 * yScalingFactor))
	bezierPath.addLine(to: CGPoint.init(x: 20 * xScalingFactor, y: -0 * yScalingFactor))
	bezierPath.close()
	color.setStroke()
	bezierPath.lineWidth = 2.0 * lineWidthScalingFactor
	bezierPath.stroke()


	//// Bezier 2 Drawing
	let bezier2Path = UIBezierPath()
	bezier2Path.move(to: CGPoint.init(x: 0.5 * xScalingFactor, y: 19.5 * yScalingFactor))
	bezier2Path.addLine(to: CGPoint.init(x: 39.5 * xScalingFactor, y: 19.5 * yScalingFactor))
	bezier2Path.addLine(to: CGPoint.init(x: 0.5 * xScalingFactor, y: 19.5 * yScalingFactor))
	bezier2Path.close()
	color.setStroke()
	bezier2Path.lineWidth = 2.0 * lineWidthScalingFactor
	bezier2Path.stroke()


	//// Bezier 3 Drawing
	let bezier3Path = UIBezierPath()
	bezier3Path.move(to: CGPoint.init(x: 21.63 * xScalingFactor, y: 0.42 * yScalingFactor))
	bezier3Path.addCurve(to: CGPoint.init(x: 21.63 * xScalingFactor, y: 39.6 * yScalingFactor), controlPoint1: CGPoint.init(x: 21.63 * xScalingFactor, y: 0.42 * yScalingFactor), controlPoint2: CGPoint.init(x: 41 * xScalingFactor, y: 19 * yScalingFactor))
	bezier3Path.lineCapStyle = .round;

	color.setStroke()
	bezier3Path.lineWidth = 2.0 * lineWidthScalingFactor
	bezier3Path.stroke()


	//// Bezier 4 Drawing
	let bezier4Path = UIBezierPath()
	bezier4Path.move(to: CGPoint.init(x: 17.76 * xScalingFactor, y: 0.74 * yScalingFactor))
	bezier4Path.addCurve(to: CGPoint.init(x: 18.72 * xScalingFactor, y: 39.6 * yScalingFactor), controlPoint1: CGPoint.init(x: 17.76 * xScalingFactor, y: 0.74 * yScalingFactor), controlPoint2: CGPoint.init(x: -2.5 * xScalingFactor, y: 19.04 * yScalingFactor))
	bezier4Path.lineCapStyle = .round;

	color.setStroke()
	bezier4Path.lineWidth = 2.0 * lineWidthScalingFactor
	bezier4Path.stroke()


	//// Bezier 5 Drawing
	let bezier5Path = UIBezierPath()
	bezier5Path.move(to: CGPoint.init(x: 6 * xScalingFactor, y: 7 * yScalingFactor))
	bezier5Path.addCurve(to: CGPoint.init(x: 34 * xScalingFactor, y: 7 * yScalingFactor), controlPoint1: CGPoint.init(x: 6 * xScalingFactor, y: 7 * yScalingFactor), controlPoint2: CGPoint.init(x: 19 * xScalingFactor, y: 21 * yScalingFactor))
	bezier5Path.lineCapStyle = .round;

	color.setStroke()
	bezier5Path.lineWidth = 2.0 * lineWidthScalingFactor
	bezier5Path.stroke()


	//// Bezier 6 Drawing
	let bezier6Path = UIBezierPath()
	bezier6Path.move(to: CGPoint.init(x: 6 * xScalingFactor, y: 33 * yScalingFactor))
	bezier6Path.addCurve(to: CGPoint.init(x: 34 * xScalingFactor, y: 33 * yScalingFactor), controlPoint1: CGPoint.init(x: 6 * xScalingFactor, y: 33 * yScalingFactor), controlPoint2: CGPoint.init(x: 19 * xScalingFactor, y: 22 * yScalingFactor))
	bezier6Path.lineCapStyle = .round;

	color.setStroke()
	bezier6Path.lineWidth = 2.0 * lineWidthScalingFactor
	bezier6Path.stroke()

	context!.restoreGState()

	endCenter()
}

func drawReturn(bounds: CGRect, color: UIColor) {
	let factors = getFactors(CGSize.init(width: 37, height: 31), toRect: bounds)
	let xScalingFactor = factors.xScalingFactor
	let yScalingFactor = factors.yScalingFactor
	_ = factors.lineWidthScalingFactor

	centerShape(CGSize.init(width: 37 * xScalingFactor, height: 31 * yScalingFactor), toRect: bounds)

	//// General Declarations
	let context = UIGraphicsGetCurrentContext()

	//// Group
	context!.saveGState()
	context!.translateBy(x: 1, y: 0.5)
	context!.scaleBy(x: 0.5, y: 0.5)


	//// Bezier 5 Drawing
	let bezier5Path = UIBezierPath()
	bezier5Path.move(to: CGPoint.init(x: 9, y: 17))
	bezier5Path.addLine(to: CGPoint.init(x: 5, y: 17))
	bezier5Path.addLine(to: CGPoint.init(x: 3, y: 17))
	bezier5Path.addLine(to: CGPoint.init(x: 1, y: 16.11))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 14.32))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 12.53))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 10.74))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 9.84))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 8.95))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 5.37))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 3.58))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 1.79))
	bezier5Path.addLine(to: CGPoint.init(x: 0, y: 0))
	bezier5Path.lineCapStyle = .square;

	bezier5Path.lineJoinStyle = .bevel;

	color.setStroke()
	bezier5Path.lineWidth = 3
	bezier5Path.stroke()


	//// Bezier 6 Drawing
	context!.saveGState()
	context!.translateBy(x: 29.36, y: 15.25)

	let bezier6Path = UIBezierPath()
	bezier6Path.move(to: CGPoint.init(x: -1.36, y: -0.75))
	bezier6Path.addLine(to: CGPoint.init(x: -1.36, y: 2.75))
	bezier6Path.addLine(to: CGPoint.init(x: -1.36, y: -0.75))
	bezier6Path.addLine(to: CGPoint.init(x: -1.36, y: 2.75))
	bezier6Path.lineCapStyle = .square;

	color.setStroke()
	bezier6Path.lineWidth = 2.5
	bezier6Path.stroke()

	context!.restoreGState()


	//// Bezier 2 Drawing
	let bezier2Path = UIBezierPath()
	bezier2Path.move(to: CGPoint.init(x: 10, y: 17))
	bezier2Path.addCurve(to: CGPoint.init(x: 26, y: 17), controlPoint1: CGPoint.init(x: 25.18, y: 17), controlPoint2: CGPoint.init(x: 26, y: 17))
	bezier2Path.lineCapStyle = .square;

	bezier2Path.lineJoinStyle = .round;

	color.setStroke()
	bezier2Path.lineWidth = 3
	bezier2Path.stroke()


	//// Bezier 4 Drawing
	let bezier4Path = UIBezierPath()
	bezier4Path.move(to: CGPoint.init(x: 32.5, y: 16))
	bezier4Path.addCurve(to: CGPoint.init(x: 20.5,y: 26), controlPoint1: CGPoint.init(x: 21.25, y: 25.37), controlPoint2: CGPoint.init(x: 20.5, y: 26))
	color.setStroke()
	bezier4Path.lineWidth = 3
	bezier4Path.stroke()


	//// Bezier Drawing
	let bezierPath = UIBezierPath()
	bezierPath.move(to: CGPoint.init(x: 33,y: 17.5))
	bezierPath.addCurve(to: CGPoint.init(x: 20.5, y: 8), controlPoint1: CGPoint.init(x: 21.28, y: 8.59), controlPoint2: CGPoint.init(x: 20.5, y: 8))
	color.setStroke()
	bezierPath.lineWidth = 3
	bezierPath.stroke()


	//// Bezier 3 Drawing
	let bezier3Path = UIBezierPath()
	bezier3Path.move(to: CGPoint.init(x: 28,y: 17))
	bezier3Path.addLine(to: CGPoint.init(x: 30,y: 17))
	color.setStroke()
	bezier3Path.lineWidth = 2.5
	bezier3Path.stroke()



	context!.restoreGState()


	endCenter()
}
