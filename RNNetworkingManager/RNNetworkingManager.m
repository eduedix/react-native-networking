//
//  RNNetworkingManager.m
//  RNNetworking
//
//  Created by Erdem Başeğmez on 18.06.2015.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNNetworkingManager.h"
#import "AFHTTPSessionManager.h"
#import "AFURLSessionManager.h"

@implementation RNNetworkingManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(requestFile:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                  callback:(RCTResponseSenderBlock)callback) {



  NSMutableDictionary *output = [[NSMutableDictionary alloc] init];
  NSURL *url = [NSURL URLWithString:URLString];
    
  NSString *method;
//  NSDictionary *headers;
  NSDictionary *data;

  if ([parameters count] != 0) {
    method = parameters[@"method"];
//    headers = parameters[@"headers"];
    data = parameters[@"data"];
  } else {
    method = @"GET";
  }

  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

  if (data[@"token"]) {
    // check body content and find token
    NSString *user = data[@"token"];
//    NSString *password;
    NSString *host = [url host];
    NSNumber *port = [url port];
    NSString *protocol = [url scheme];
    NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:host port:[port integerValue] protocol:protocol realm:nil authenticationMethod:NSURLAuthenticationMethodHTTPBasic];

    NSURLCredential *defaultCredential = [NSURLCredential credentialWithUser:user password:NULL persistence:NSURLCredentialPersistencePermanent];

    NSURLCredentialStorage *credentials = [NSURLCredentialStorage sharedCredentialStorage];
    [credentials setDefaultCredential:defaultCredential forProtectionSpace:protectionSpace];

    [configuration setURLCredentialStorage: credentials];
  }

  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

  if ([method isEqualToString:@"GET"]) {
    // request serializer: json
    // response serializer: formdata multipart file

    // input: url, parameters
    // request: json: get file
    // response: file
    // output: filepath

//    NSDictionary *parameters = @{};
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:URLString parameters:parameters error:nil];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
      // find the Documents directory for the app
      NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
      // set destination to Documents/response.suggestedFilename
      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
      if (error) {
        [output setObject:[error localizedDescription] forKey:@"error"];
      } else {
        [output setObject:@{@"response": [NSNumber numberWithInteger:[(NSHTTPURLResponse *)response statusCode]], @"filePath": [filePath lastPathComponent]} forKey:@"success"];
//        NSLog(@"%@", [filePath relativePath]);
//        NSLog(@"%@", [filePath path]);
//        NSLog(@"%@", [filePath absoluteString]);
//        NSLog(@"%@", [filePath lastPathComponent]);

      }
      callback(@[output]);
    }];
    [downloadTask resume];

  } else if ([method isEqualToString:@"POST"]) {
    // request serializer: formdata multipart file
    // response: response object (json)

    // input: url, filepath
    // request: post file
    // response: success or error JSON
    // output: success or error

    // multi-part upload task
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:data[@"file"] ];

    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

      [formData appendPartWithFileURL:fileURL name:@"file" fileName:@"fileName.mp4" mimeType:@"video/mp4" error:nil];
    } error:nil];

    NSProgress *progress;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
      if (error) {
        [output setObject:[error localizedDescription] forKey:@"error"];
      } else {
        [output setObject:@{@"response": [NSNumber numberWithInteger:[(NSHTTPURLResponse *)response statusCode]], @"responseObject": responseObject} forKey:@"success"];
      }
      callback(@[output]);
    }];
    [uploadTask resume];
  }
}

@end
