//
//  main.m
//  IDT
//
//  Created by Joseph Afework on 2/24/15.
//  Copyright (c) 2015 Joseph Afework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // Parse Arguments
        NSString *path = [[NSFileManager defaultManager] currentDirectoryPath];
        
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        
        NSString *threshold = arguments[3];
        
        BOOL verbose = NO;
        if(arguments.count == 5)
        {
            verbose = YES;
        }
        
        // Load Refrence Image
        NSString *referencePath = [path stringByAppendingPathComponent:arguments[1]];
        NSImage *referenceImage = [[NSImage alloc] initWithContentsOfFile:referencePath];

        // Load Test Image
        NSString *testPath = [path stringByAppendingPathComponent:arguments[2]];
        NSImage *testImage = [[NSImage alloc] initWithContentsOfFile:testPath];
        
        // Load Bitmap Representation of Reference Image
        NSBitmapImageRep * referenceBitmap = [NSBitmapImageRep imageRepWithData:referenceImage.TIFFRepresentation];
        NSInteger w = referenceBitmap.pixelsWide;
        NSInteger h = referenceBitmap.pixelsHigh;
        
        // Load Bitmap Representation of Test Image
        NSBitmapImageRep * testBitmap = [NSBitmapImageRep imageRepWithData:testImage.TIFFRepresentation];
        
        // Init Pixel Arrays of Images
        unsigned char *referencePixels = referenceBitmap.bitmapData;
        unsigned char *testPixels = testBitmap.bitmapData;
        
        int index = 0;
        
        // Count of Incorrect Pixels
        int noMatch = 0;
        
        // Iterate Across All Pixels in Test Image and Compare RGB Values to Refrence Image
        for ( int i = 0; i < w; ++i )
        {
            for ( int j = 0; j < h; ++j )
            {
                // If Pixel Is Different In Test Image, Set Output Pixel to RED to Easily Show Difference
                if(referencePixels[index] != testPixels[index] || referencePixels[index+1] != testPixels[index+1] || referencePixels[index+2] != testPixels[index+2])
                {
                    referencePixels[index] = 255;
                    referencePixels[index+1] = 0;
                    referencePixels[index+2] = 0;
                    noMatch++;
                }
            
                index+=3;
            }
        }
        
        // Output Diff Image
        NSData * byteData = [NSData dataWithBytes:referencePixels length:index];
        NSBitmapImageRep * imageRep = [NSBitmapImageRep imageRepWithData:byteData];
        NSSize imageSize = NSMakeSize(CGImageGetWidth([imageRep CGImage]), CGImageGetHeight([imageRep CGImage]));
        NSImage * image = [[NSImage alloc] initWithSize:imageSize];
        [image addRepresentation:referenceBitmap];
        
        NSData *data = [referenceBitmap representationUsingType: NSPNGFileType properties: nil];
        NSString *output = [path stringByAppendingPathComponent:@"diff.png"];
        [data writeToFile: output atomically: NO];
        
        // Output Pass or Fail Based on Threshold Comparison
        int differentPixels = noMatch;
        long totalPixels = h * w;
        
        if(verbose)
        {
            printf("%s", output.UTF8String);
            printf("%d of %ld : %lf change", differentPixels, totalPixels,(double)noMatch/(totalPixels));
        }
        
        if(threshold.integerValue == -1)
        {
            if(differentPixels != 0)
            {
                printf("fail");
            }
            else
            {
                printf("pass");
            }
        }
        else
        {
            // Check Threshold
            int percentChanged = ((double)differentPixels/(totalPixels)) * 100;
            if(percentChanged <= threshold.integerValue)
            {
                printf("pass");
            }
            else
            {
                printf("fail");
            }
        }
    }
    return 0;
}
