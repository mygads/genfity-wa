# Genfity Wa

<img src="static/favicon.ico" width="30"> Genfity Wa is an implementation 
of the [@tulir/whatsmeow](https://github.com/tulir/whatsmeow) library as a 
simple RESTful API service with multiple device support and concurrent 
sessions.

Whatsmeow does not use Puppeteer on headless Chrome, nor an Android emulator. It communicates directly with WhatsApp’s WebSocket servers, making it significantly faster and much less demanding on memory and CPU than those solutions. The drawback is that any changes to the WhatsApp protocol could break connections, requiring a library update.

## :warning: Warning

**Using this software in violation of WhatsApp’s Terms of Service can get your number banned**:  
Be very careful—do not use this to send SPAM or anything similar. Use at your own risk. If you need to develop something for commercial purposes, contact a WhatsApp global solution provider and sign up for the WhatsApp Business API service instead.
 
## Available endpoints

* **Session:** Connect, disconnect, and log out from WhatsApp. Retrieve connection status and QR codes for scanning.
* **Messages:** Send text, image, audio, document, template, video, sticker, location, contact, and poll messages.
* **Users:** Check if phone numbers have WhatsApp, get user information and avatars, and retrieve the full contact list.
* **Chat:** Set presence (typing/paused, recording media), mark messages as read, download images from messages, send reactions.
* **Groups:** Create, delete and list groups, get info, get invite links, set participants, change group photos and names.
* **Webhooks:** Set and get webhooks that will be called whenever events or messages are received.
 
## Prerequisites

**Required:**
* Go (Go Programming Language)

**Optional:**
* Docker (for containerization)

## Updating dependencies

This project uses the whatsmeow library to communicate with WhatsApp. To update the library to the latest version, run:

```bash
go get -u go.mau.fi/whatsmeow@latest
go mod tidy
```

## Building

```
go build .
```

## Run

By default it will start a REST service in port 8080. These are the parameters
you can use to alter behaviour

* -admintoken  : sets authentication token for admin endpoints. If not specified it will be read from .env
* -address  : sets the IP address to bind the server to (default 0.0.0.0)
* -port  : sets the port number (default 8080)
* -logtype : format for logs, either console (default) or json
* -color : enable colored output for console logs
* -osname : Connection OS Name in Whatsapp
* -skipmedia : Skip downloading media from messages
* -wadebug : enable whatsmeow debug, either INFO or DEBUG levels are suported
* -sslcertificate : SSL Certificate File
* -sslprivatekey : SSL Private Key File

Example:

To have colored logs:

```
./genfity-wa -logtype=console -color=true
```

For JSON logs:

```
./genfity-wa -logtype json 
```

With time zone: 

Set `TZ=America/New_York ./genfity-wa ...` in your shell or in your .env file or Docker Compose environment: `TZ=America/New_York`.  

## Configuration

Genfity Wa uses a <code>.env</code> file for configuration. Here are the required settings:

### For PostgreSQL
```
Genfity_ADMIN_TOKEN=your_admin_token_here
DB_USER=genfity
DB_PASSWORD=genfity
DB_NAME=genfity
DB_HOST=localhost
DB_PORT=5432
DB_SSLMODE=false
TZ=America/New_York
WEBHOOK_FORMAT=json # or "form" for the default
SESSION_DEVICE_NAME=genfity
```

### For SQLite
```
WA_ADMIN_TOKEN=your_admin_token_here
TZ=America/New_York
```

### RabbitMQ Integration
Genfity supports sending WhatsApp events to a RabbitMQ queue for global event distribution. When enabled, all WhatsApp events will be published to the specified queue regardless of individual user webhook configurations.

Set these environment variables to enable RabbitMQ integration:

```
RABBITMQ_URL=amqp://guest:guest@localhost:5672
RABBITMQ_QUEUE=whatsapp  # Optional (default: whatsapp_events)
```

When enabled:

* All WhatsApp events (messages, presence updates, etc.) will be published to the configured queue regardless of event subscritions for regular webhooks
* Events will include the userId and instanceName
* This works alongside webhook configurations - events will be sent to both RabbitMQ and any configured webhooks
* The integration is global and affects all instances

#### Key configuration options:

* WA_ADMIN_TOKEN: Required - Authentication token for admin endpoints
* TZ: Optional - Timezone for server operations (default: UTC)
* PostgreSQL-specific options: Only required when using PostgreSQL backend
* RabbitMQ options: Optional, only required if you want to publish events to RabbitMQ

## Usage

To interact with the API, you must include the `Authorization` header in HTTP requests, containing the user's authentication token. You can have multiple users (different WhatsApp numbers) on the same server.  

* A Swagger API reference at [/api](/api)
* A sample web page to connect and scan QR codes at [/login](/login)
* A fully featured Dashboard to create, manage and test instances at [/dashboard](dashboard)

## ADMIN Actions

You can list, add and remove users using the admin endpoints. For that you must use the WA_ADMIN_TOKEN in the Authorization header

Then you can use the /admin/users endpoint with the Authorization header containing the token to:

- `GET /admin/users` - List all users
- `POST /admin/users` - Create a new user
- `DELETE /admin/users/{id}` - Remove a user

The JSON body for creating a new user must contain:

- `name` [string] : User's name 
- `token` [string] : Security token to authorize/authenticate this user
- `webhook` [string] : URL to send events via POST (optional)
- `events` [string] : Comma-separated list of events to receive (required) - Valid events are: "Message", "ReadReceipt", "Presence", "HistorySync", "ChatPresence", "All"
- `expiration` [int] : Expiration timestamp (optional, not enforced by the system)

## User Creation with Optional Proxy and S3 Configuration

You can create a user with optional proxy and S3 storage configuration. All fields are optional and backward compatible. If you do not provide these fields, the user will be created with default settings.

### Example Payload

```json
{
  "name": "test_user",
  "token": "user_token",
  "proxyConfig": {
    "enabled": true,
    "proxyURL": "socks5://user:pass@host:port"
  },
  "s3Config": {
    "enabled": true,
    "endpoint": "https://s3.amazonaws.com",
    "region": "us-east-1",
    "bucket": "my-bucket",
    "accessKey": "AKIAIOSFODNN7EXAMPLE",
    "secretKey": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    "pathStyle": false,
    "publicURL": "https://cdn.yoursite.com",
    "mediaDelivery": "both",
    "retentionDays": 30
  }
}
```

- `proxyConfig` (object, optional):
  - `enabled` (boolean): Enable proxy for this user.
  - `proxyURL` (string): Proxy URL (e.g., `socks5://user:pass@host:port`).
- `s3Config` (object, optional):
  - `enabled` (boolean): Enable S3 storage for this user.
  - `endpoint` (string): S3 endpoint URL.
  - `region` (string): S3 region.
  - `bucket` (string): S3 bucket name.
  - `accessKey` (string): S3 access key.
  - `secretKey` (string): S3 secret key.
  - `pathStyle` (boolean): Use path style addressing.
  - `publicURL` (string): Public URL for accessing files.
  - `mediaDelivery` (string): Media delivery type (`base64`, `s3`, or `both`).
  - `retentionDays` (integer): Number of days to retain files.

If you omit `proxyConfig` or `s3Config`, the user will be created without proxy or S3 integration, maintaining full backward compatibility.

## API reference 

API calls should be made with content type json, and parameters sent into the
request body, always passing the Token header for authenticating the request.

Check the [API Reference](https://wa.genfity.com/api/)

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=asternic/genfity&type=Date)](https://www.star-history.com/#asternic/genfity&Date)

## License

Copyright &copy; 2025 Nicolás Gudiño and contributors

[MIT](https://choosealicense.com/licenses/mit/)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Icon Attribution

[Communication icons created by Vectors Market -
Flaticon](https://www.flaticon.com/free-icons/communication)

## Legal

This code is in no way affiliated with, authorized, maintained, sponsored or
endorsed by WhatsApp or any of its affiliates or subsidiaries. This is an
independent and unofficial software. Use at your own risk.

## Cryptography Notice

This distribution includes cryptographic software. The country in which you
currently reside may have restrictions on the import, possession, use, and/or
re-export to another country, of encryption software. BEFORE using any
encryption software, please check your country's laws, regulations and policies
concerning the import, possession, or use, and re-export of encryption
software, to see if this is permitted. See
[http://www.wassenaar.org/](http://www.wassenaar.org/) for more information.

The U.S. Government Department of Commerce, Bureau of Industry and Security
(BIS), has classified this software as Export Commodity Control Number (ECCN)
5D002.C.1, which includes information security software using or performing
cryptographic functions with asymmetric algorithms. The form and manner of this
distribution makes it eligible for export under the License Exception ENC
Technology Software Unrestricted (TSU) exception (see the BIS Export
Administration Regulations, Section 740.13) for both object code and source
code.
