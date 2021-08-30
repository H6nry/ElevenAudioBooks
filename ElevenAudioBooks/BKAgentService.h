//
//  BKAgentService.h
//  ElevenAudioBooks
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BCSyncICloudSettingsProtocol
- (void)setLiverpoolEnabled:(BOOL)arg1 liverpoolAndUbiquityEnabledStatusReply:(void (^)(BOOL, BOOL))arg2;
@end

@protocol BKAgentService <NSObject, BCSyncICloudSettingsProtocol>
- (void)simulateUploadFailure:(NSDictionary *)arg1 withReply:(void (^)(NSError *))arg2;
- (void)simulateUploadEnd:(NSDictionary *)arg1 withReply:(void (^)(NSError *))arg2;
- (void)simulateUploadProgress:(NSDictionary *)arg1 withReply:(void (^)(NSError *))arg2;
- (void)simulateUbiquityDidLoadWithFilesPaths:(NSArray *)arg1 reply:(void (^)(void))arg2;
- (void)simulateUbiquityFileDidBecomeUnavilableAtPath:(NSString *)arg1 withReply:(void (^)(void))arg2;
- (void)simulateUbiquityFileDidBecomeAvailableAtPath:(NSString *)arg1 withReply:(void (^)(void))arg2;
- (void)setUserDefaultsEnabled:(BOOL)arg1 reply:(void (^)(void))arg2;
- (void)setUbiquityDirectoriesSubpath:(NSString *)arg1 withReply:(void (^)(BOOL))arg2;
- (void)performUbiquityMigration:(void (^)(NSArray *, NSError *))arg1;
- (void)getUseriCloudSetting:(void (^)(BOOL, BOOL, NSData *, NSDictionary *, NSDictionary *, NSDictionary *, NSError *))arg1;
- (void)setUseriCloudSetting:(BOOL)arg1 results:(void (^)(BOOL, NSData *, NSDictionary *, NSDictionary *, NSDictionary *, NSError *))arg2;
- (void)shutdownService:(void (^)(id, NSError *))arg1;
- (void)validateAuthorization:(void (^)(id, NSError *))arg1;
- (void)moveAsideLibraryStore:(NSURL *)arg1 withToken:(NSData *)arg2 results:(void (^)(id, NSError *))arg3;
- (void)chooseLibrary:(NSURL *)arg1 withToken:(NSData *)arg2 results:(void (^)(id, NSError *))arg3;
- (void)moveLibrary:(NSURL *)arg1 withToken:(NSData *)arg2 results:(void (^)(id, NSError *))arg3;
- (void)reconnectToLibrary:(void (^)(id, NSError *))arg1;
- (void)fixOrphanedFiles:(void (^)(id, NSError *))arg1;
- (void)rebuildLibrary:(void (^)(id, NSError *))arg1;
- (void)prepareToOpenAsset:(NSString *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)applyPendingUpdates:(void (^)(id, NSError *))arg1;
- (void)removeRedactedBook:(NSDictionary *)arg1 withReply:(void (^)(id, NSError *))arg2;
- (void)fetchRedactedBooks:(void (^)(id, NSError *))arg1;
- (void)redactBook:(NSDictionary *)arg1 withReply:(void (^)(id, NSError *))arg2;
- (void)examineBook:(NSURL *)arg1 withToken:(NSData *)arg2 includeCover:(BOOL)arg3 results:(void (^)(id, NSError *))arg4;
- (void)uncompressBook:(NSDictionary *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)migrateBook:(NSURL *)arg1 withToken:(NSData *)arg2 withMetadata:(NSDictionary *)arg3 withCopy:(BOOL)arg4 results:(void (^)(id, NSError *))arg5;
- (void)prioritizeImport:(NSString *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)evictBook:(NSURL *)arg1 withToken:(NSData *)arg2 results:(void (^)(id, NSError *))arg3;
- (void)trashBook:(NSDictionary *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)removeBook:(NSDictionary *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)updateBook:(NSURL *)arg1 withToken:(NSData *)arg2 withMetadata:(NSDictionary *)arg3 results:(void (^)(id, NSError *))arg4;
- (void)importBook:(NSURL *)arg1 withToken:(NSData *)arg2 withMetadata:(NSDictionary *)arg3 results:(void (^)(id, NSError *))arg4;
- (void)importBook:(NSURL *)arg1 withToken:(NSData *)arg2 results:(void (^)(id, NSError *))arg3;
- (void)fetchImportingBooks:(void (^)(id, NSError *))arg1;
- (void)fetchBooksPartsWithAssetID:(NSString *)arg1 result:(void (^)(id, NSError *))arg2;
- (void)fetchCompleteBooksWithAssetIDs:(NSArray *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)fetchBooksWithAssetIDs:(NSArray *)arg1 results:(void (^)(id, NSError *))arg2;
- (void)fetchBookAssetIDs:(void (^)(id, NSError *))arg1;
- (void)fetchCompleteBooks:(void (^)(id, NSError *))arg1;
- (void)fetchBooks:(void (^)(id, NSError *))arg1;
- (void)fetchBookLibraryTokens:(void (^)(id, NSError *))arg1;
@end

NS_ASSUME_NONNULL_END
