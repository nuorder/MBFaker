//
//  MBFakerInternet.m
//  Faker
//
//  Created by Michał Banasiak on 11/7/12.
//  Copyright (c) 2012 Michał Banasiak. All rights reserved.
//

#import "MBFakerInternet.h"
#import "MBFaker.h"

@implementation MBFakerInternet

+ (NSString*)email {
    return [NSString stringWithFormat:@"%@@%@", [MBFakerInternet userName], [MBFakerInternet domainName] ];
}

+ (NSString*)freeEmail {
    return [NSString stringWithFormat:@"%@@%@", [MBFakerInternet userName] , [[[MBFaker sharedFaker] fetchStringWithKey:@"internet.free_email"] lowercaseString]];
}

+ (NSString*)safeEmail {
    return [self freeEmail];
}

+ (NSString*)userName {
    NSMutableArray* components = [[NSMutableArray alloc] init];
    
    for (int i=0; i<1+arc4random()%2;i++) {
        if (i == 0)
            [components addObject:[self fixUmlauts:[MBFakerName firstName]]];
        else
            [components addObject:[self fixUmlauts:[MBFakerName lastName]]];
    }
    
    return [[components componentsJoinedByString:@"."] lowercaseString];
}

+ (NSString*)domainName {
    NSString *name = [NSString stringWithFormat: @"%@.%@", [self domainWord], [self domainSuffix]];
    return name;
}

+ (NSString*)domainWord {
    NSString *name = [(NSString*)[[MBFakerCompany name] componentsSeparatedByString: @" "][0] lowercaseString];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\W" options:NSRegularExpressionCaseInsensitive error: NULL];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, [name length]) withTemplate:@""];
    
    return [self fixUmlauts:modifiedString];
}

+ (NSString *)fixUmlauts:(NSString *)dirtyString {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\[äöüß]"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    NSMutableString *mutableString = [[dirtyString lowercaseString] mutableCopy];
    NSInteger offset = 0;
    
    for (NSTextCheckingResult *result in [regex matchesInString:dirtyString
                                                        options:0
                                                          range:NSMakeRange(0, [dirtyString length])]) {
        
        NSRange resultRange = [result range];
        resultRange.location += offset;
        
        NSString *match = [regex replacementStringForResult:result
                                                   inString:mutableString
                                                     offset:offset
                                                   template:@"$0"];
        NSString *replacement;
        if ([match isEqualToString:@"ä"]) {
            replacement = @"ae";
        } else if ([match isEqualToString:@"ö"]) {
            replacement = @"oe";
        } else if ([match isEqualToString:@"ü"]) {
            replacement = @"ue";
        }else if ([match isEqualToString:@"ß"]) {
            replacement = @"ss";
        }
        
        [mutableString replaceCharactersInRange:resultRange withString:replacement];
        offset += ([replacement length] - resultRange.length);
    }
    
    return [mutableString copy];
}

+ (NSString*)domainSuffix {
    return [[MBFaker sharedFaker] fetchStringWithKey:@"internet.domain_suffix"];
}

+ (NSString*)ipV4Address {
    return [NSString stringWithFormat:@"%d.%d.%d.%d", 2+arc4random()%253, 2+arc4random()%253, 2+arc4random()%253, 2+arc4random()%253];
}

+ (NSString*)ipV6Address {
    NSMutableArray* components = [[NSMutableArray alloc] initWithCapacity:8];
    
    for (int i=0; i<8; i++)
         [components addObject:[NSString stringWithFormat:@"%X", arc4random()%65535]];
    
    return [components componentsJoinedByString:@":"];
}

+ (NSString*)url {
    return [NSString stringWithFormat:@"http://%@/%@", [MBFakerInternet domainName], [MBFakerInternet userName]];
}

/*
def email(name = nil)
[ user_name(name), domain_name ].join('@')
end

def free_email(name = nil)
[ user_name(name), fetch('internet.free_email') ].join('@')
end

def safe_email(name = nil)
[user_name(name), 'example.'+ %w[org com net].shuffle.first].join('@')
end

def user_name(name = nil)
return name.scan(/\w+/).shuffle.join(%w(. _).sample).downcase if name

fix_umlauts([
             Proc.new { Name.first_name.gsub(/\W/, '').downcase },
             Proc.new {
                 [ Name.first_name, Name.last_name ].map {|n|
                     n.gsub(/\W/, '')
                 }.join(%w(. _).sample).downcase }
             ].sample.call)
end

def domain_name
[ fix_umlauts(domain_word), domain_suffix ].join('.')
end

def fix_umlauts(string)
string.gsub(/[äöüß]/i) do |match|
case match.downcase
when "ä" 'ae'
when "ö" 'oe'
when "ü" 'ue'
when "ß" 'ss'
end
end
end

def domain_word
Company.name.split(' ').first.gsub(/\W/, '').downcase
end

def domain_suffix
fetch('internet.domain_suffix')
end

def ip_v4_address
ary = (2..254).to_a
[ary.sample,
 ary.sample,
 ary.sample,
 ary.sample].join('.')
end

def ip_v6_address
@@ip_v6_space ||= (0..65535).to_a
container = (1..8).map{ |_| @@ip_v6_space.sample }
container.map{ |n| n.to_s(16) }.join(':')
end

def url
"http://#{domain_name}/#{user_name}"
end*/


@end
