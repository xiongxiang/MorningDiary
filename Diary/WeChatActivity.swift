import UIKit
import MonkeyKing

struct ChinaSocialNetwork {
    
    struct WeChat {
        
        static let appID = "wx1f683ed6cec8c820"
        
        static let sessionType = "com.Catch-Inc.Diary.WeChat.Session"
        static let sessionTitle = "微信"
        static let sessionImage = UIImage(named: "wechat_session")!
        
        static let timelineType = "com.Catch-Inc.Diary.WeChat.Timeline"
        static let timelineTitle = "朋友圈"
        static let timelineImage = UIImage(named: "wechat_timeline")!
    }
}

class WeChatActivity: AnyActivity {
    
    enum Type {
        
        case Session
        case Timeline
        
        var type: String {
            switch self {
            case .Session:
                return ChinaSocialNetwork.WeChat.sessionType
            case .Timeline:
                return ChinaSocialNetwork.WeChat.timelineType
            }
        }
        
        var title: String {
            switch self {
            case .Session:
                return ChinaSocialNetwork.WeChat.sessionTitle
            case .Timeline:
                return ChinaSocialNetwork.WeChat.timelineTitle
            }
        }
        
        var image: UIImage {
            switch self {
            case .Session:
                return ChinaSocialNetwork.WeChat.sessionImage
            case .Timeline:
                return ChinaSocialNetwork.WeChat.timelineImage
            }
        }
    }
    
    init(type: Type, message: MonkeyKing.Message, finish: MonkeyKing.Finish) {
        
        MonkeyKing.registerAccount(.WeChat(appID: ChinaSocialNetwork.WeChat.appID))
        
        super.init(
            type: type.type,
            title: type.title,
            image: type.image,
            message: message,
            finish: finish
        )
    }
}

