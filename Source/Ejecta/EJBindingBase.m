#import "EJBindingBase.h"
#import "EJClassLoader.h"
#import <objc/runtime.h>


@implementation EJBindingBase
@synthesize scriptView;

- (id)initWithContext:(JSContextRef)ctxp argc:(size_t)argc argv:(const JSValueRef [])argv {
	if( self = [super init] ) {
	}
	return self;
}

- (void)createWithJSObject:(JSObjectRef)obj scriptView:(EJJavaScriptView *)view {
	jsObject = obj;
	scriptView = view;
}

+ (JSObjectRef)createJSObjectWithContext:(JSContextRef)ctx
	scriptView:(EJJavaScriptView *)scriptViewp
	instance:(EJBindingBase *)instance
{
	// Create JSObject with the JSClass for this ObjC-Class
	JSObjectRef obj = JSObjectMake( ctx, [EJClassLoader getJSClass:self], NULL );
	
	// The JSObject retains the instance; it will be released by EJBindingBaseFinalize
	JSObjectSetPrivate( obj, (void *)[instance retain] );
	[instance createWithJSObject:obj scriptView:scriptViewp];
	
	return obj;
}

void EJBindingBaseFinalize(JSObjectRef object) {
	id instance = (id)JSObjectGetPrivate(object);
	[instance release];
}


@end
