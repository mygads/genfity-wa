package main

// List of actively implemented and working event types
var activeEventTypes = []string{
	// Messages and Communication
	"Message",
	"MessageSent",
	"Receipt",

	// Connection and Session
	"Connected",
	"Disconnected",
	"ConnectFailure",
	"LoggedOut",
	"StreamReplaced",
	"PairSuccess",
	"QR",

	// Privacy and Settings
	"PushNameSetting",

	// Synchronization and State
	"AppState",
	"AppStateSyncComplete",
	"HistorySync",

	// Calls (logging only)
	"CallOffer",
	"CallAccept",
	"CallTerminate",
	"CallOfferNotice",
	"CallRelayLatency",

	// Presence and Activity
	"Presence",
	"ChatPresence",

	// Special - receives all events
	"All",
}

// List of all supported event types (including not yet implemented)
var supportedEventTypes = []string{
	// Messages and Communication
	"Message",
	"MessageSent",
	"UndecryptableMessage",
	"Receipt",
	"MediaRetry",
	"ReadReceipt",

	// Groups and Contacts
	"GroupInfo",
	"JoinedGroup",
	"Picture",
	"BlocklistChange",
	"Blocklist",

	// Connection and Session
	"Connected",
	"Disconnected",
	"ConnectFailure",
	"KeepAliveRestored",
	"KeepAliveTimeout",
	"LoggedOut",
	"ClientOutdated",
	"TemporaryBan",
	"StreamError",
	"StreamReplaced",
	"PairSuccess",
	"PairError",
	"QR",
	"QRScannedWithoutMultidevice",

	// Privacy and Settings
	"PrivacySettings",
	"PushNameSetting",
	"UserAbout",

	// Synchronization and State
	"AppState",
	"AppStateSyncComplete",
	"HistorySync",
	"OfflineSyncCompleted",
	"OfflineSyncPreview",

	// Calls
	"CallOffer",
	"CallAccept",
	"CallTerminate",
	"CallOfferNotice",
	"CallRelayLatency",

	// Presence and Activity
	"Presence",
	"ChatPresence",

	// Identity
	"IdentityChange",

	// Erros
	"CATRefreshError",

	// Newsletter (WhatsApp Channels)
	"NewsletterJoin",
	"NewsletterLeave",
	"NewsletterMuteChange",
	"NewsletterLiveUpdate",

	// Facebook/Meta Bridge
	"FBMessage",

	// Special - receives all events
	"All",
}

// List of not yet implemented event types
var notImplementedEventTypes = []string{
	// Messages and Communication
	"UndecryptableMessage",
	"MediaRetry",
	"ReadReceipt", // Use "Receipt" instead

	// Groups and Contacts
	"GroupInfo",
	"JoinedGroup",
	"Picture",
	"BlocklistChange",
	"Blocklist",

	// Connection and Session
	"KeepAliveRestored",
	"KeepAliveTimeout",
	"ClientOutdated",
	"TemporaryBan",
	"StreamError",
	"PairError",
	"QRScannedWithoutMultidevice",

	// Privacy and Settings
	"PrivacySettings",
	"UserAbout",

	// Synchronization and State
	"OfflineSyncCompleted",
	"OfflineSyncPreview",

	// Identity
	"IdentityChange",

	// Errors
	"CATRefreshError",

	// Newsletter (WhatsApp Channels)
	"NewsletterJoin",
	"NewsletterLeave",
	"NewsletterMuteChange",
	"NewsletterLiveUpdate",

	// Facebook/Meta Bridge
	"FBMessage",
}

// Map for quick validation
var eventTypeMap map[string]bool
var activeEventTypeMap map[string]bool

func init() {
	eventTypeMap = make(map[string]bool)
	for _, eventType := range supportedEventTypes {
		eventTypeMap[eventType] = true
	}

	activeEventTypeMap = make(map[string]bool)
	for _, eventType := range activeEventTypes {
		activeEventTypeMap[eventType] = true
	}
}

// Auxiliary function to validate event type
func isValidEventType(eventType string) bool {
	return eventTypeMap[eventType]
}

// Auxiliary function to check if event type is actively implemented
func isActiveEventType(eventType string) bool {
	return activeEventTypeMap[eventType]
}
