# Script to update Postman collection with missing endpoints
$jsonPath = "wa-api_postman.json"
$json = Get-Content $jsonPath -Raw | ConvertFrom-Json

# Find Webhook folder
$webhookFolder = $json.item | Where-Object { $_.name -eq 'Webhook' }

# Add "Get Webhook Events" endpoint to Webhook folder
$getWebhookEvents = @{
    name = "Get Webhook Events"
    request = @{
        method = "GET"
        header = @()
        url = @{
            raw = "{{baseUrl}}/webhook/events?active=true"
            host = @("{{baseUrl}}")
            path = @("webhook", "events")
            query = @(
                @{
                    key = "active"
                    value = "true"
                    description = "Set to 'true' to get only active events, omit to get all events"
                    disabled = $false
                }
            )
        }
        description = "Get list of available webhook events. Returns all supported events, active events, and not implemented events. No authentication required."
    }
    response = @()
}

# Check if endpoint already exists
$existingWebhookEvents = $webhookFolder.item | Where-Object { $_.name -eq "Get Webhook Events" }
if (-not $existingWebhookEvents) {
    $webhookFolder.item += $getWebhookEvents
    Write-Host "✅ Added: GET /webhook/events" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: GET /webhook/events" -ForegroundColor Yellow
}

# Find Session folder
$sessionFolder = $json.item | Where-Object { $_.name -eq 'Session' }

# Add "Set History Configuration" endpoint
$setHistory = @{
    name = "Set History Configuration"
    request = @{
        method = "POST"
        header = @(
            @{
                key = "token"
                value = "{{token}}"
            },
            @{
                key = "Content-Type"
                value = "application/json"
            }
        )
        body = @{
            mode = "raw"
            raw = "{\n  `"history`": 500\n}"
        }
        url = @{
            raw = "{{baseUrl}}/session/history"
            host = @("{{baseUrl}}")
            path = @("session", "history")
        }
        description = "Configure message history storage. Set history to 0 to disable, or any positive number to enable with that limit. Example: 500 will store last 500 messages per chat."
    }
    response = @()
}

$existingSetHistory = $sessionFolder.item | Where-Object { $_.name -eq "Set History Configuration" }
if (-not $existingSetHistory) {
    $sessionFolder.item += $setHistory
    Write-Host "✅ Added: POST /session/history" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: POST /session/history" -ForegroundColor Yellow
}

# Find Chat folder
$chatFolder = $json.item | Where-Object { $_.name -eq 'Chat' }

# Add "Get Message History" endpoint
$getHistory = @{
    name = "Get Message History"
    request = @{
        method = "GET"
        header = @(
            @{
                key = "token"
                value = "{{token}}"
            }
        )
        url = @{
            raw = "{{baseUrl}}/chat/history?chat_jid=628123456789@s.whatsapp.net&limit=50"
            host = @("{{baseUrl}}")
            path = @("chat", "history")
            query = @(
                @{
                    key = "chat_jid"
                    value = "628123456789@s.whatsapp.net"
                    description = "JID of the chat to retrieve history from. Use 'index' to get all chats mapping."
                },
                @{
                    key = "limit"
                    value = "50"
                    description = "Number of messages to retrieve (default: 50)"
                }
            )
        }
        description = "Retrieve message history for a specific chat. Requires history to be enabled via POST /session/history. Use chat_jid=index to get mapping of all user instances and their chats."
    }
    response = @()
}

$existingGetHistory = $chatFolder.item | Where-Object { $_.name -eq "Get Message History" }
if (-not $existingGetHistory) {
    $chatFolder.item += $getHistory
    Write-Host "✅ Added: GET /chat/history" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: GET /chat/history" -ForegroundColor Yellow
}

# Add "Send Poll" endpoint if not exists
$sendPoll = @{
    name = "Send Poll"
    request = @{
        method = "POST"
        header = @(
            @{
                key = "token"
                value = "{{token}}"
            },
            @{
                key = "Content-Type"
                value = "application/json"
            }
        )
        body = @{
            mode = "raw"
            raw = "{\n  `"group`": `"120363313346913103@g.us`",\n  `"header`": `"What is your favorite color?`",\n  `"options`": [`"Red`", `"Blue`", `"Green`", `"Yellow`"],\n  `"Id`": `"`"\n}"
        }
        url = @{
            raw = "{{baseUrl}}/chat/send/poll"
            host = @("{{baseUrl}}")
            path = @("chat", "send", "poll")
        }
        description = "Send a poll to a group. Minimum 2 options required. Maximum 1 selection allowed."
    }
    response = @()
}

$existingSendPoll = $chatFolder.item | Where-Object { $_.name -eq "Send Poll" }
if (-not $existingSendPoll) {
    $chatFolder.item += $sendPoll
    Write-Host "✅ Added: POST /chat/send/poll" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: POST /chat/send/poll" -ForegroundColor Yellow
}

# Find User folder
$userFolder = $json.item | Where-Object { $_.name -eq 'User' }

# Add "Set Status Text" endpoint
$setStatusText = @{
    name = "Set Status Text"
    request = @{
        method = "POST"
        header = @(
            @{
                key = "token"
                value = "{{token}}"
            },
            @{
                key = "Content-Type"
                value = "application/json"
            }
        )
        body = @{
            mode = "raw"
            raw = "{\n  `"Body`": `"Available - Powered by Genfity WA`"\n}"
        }
        url = @{
            raw = "{{baseUrl}}/status/set/text"
            host = @("{{baseUrl}}")
            path = @("status", "set", "text")
        }
        description = "Set WhatsApp profile status message."
    }
    response = @()
}

$existingSetStatus = $userFolder.item | Where-Object { $_.name -eq "Set Status Text" }
if (-not $existingSetStatus) {
    $userFolder.item += $setStatusText
    Write-Host "✅ Added: POST /status/set/text" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: POST /status/set/text" -ForegroundColor Yellow
}

# Add "Get User LID" endpoint
$getUserLID = @{
    name = "Get User LID"
    request = @{
        method = "GET"
        header = @(
            @{
                key = "token"
                value = "{{token}}"
            }
        )
        url = @{
            raw = "{{baseUrl}}/user/lid/628123456789@s.whatsapp.net"
            host = @("{{baseUrl}}")
            path = @("user", "lid", "628123456789@s.whatsapp.net")
        }
        description = "Get User Linked ID (LID) for a specific JID."
    }
    response = @()
}

$existingGetLID = $userFolder.item | Where-Object { $_.name -eq "Get User LID" }
if (-not $existingGetLID) {
    $userFolder.item += $getUserLID
    Write-Host "✅ Added: GET /user/lid/{jid}" -ForegroundColor Green
} else {
    Write-Host "⚠️  Already exists: GET /user/lid/{jid}" -ForegroundColor Yellow
}

# Save updated JSON
$json | ConvertTo-Json -Depth 100 | Set-Content $jsonPath -Encoding UTF8

Write-Host "`n✅ Postman collection updated successfully!" -ForegroundColor Green
Write-Host "📁 File: $jsonPath" -ForegroundColor Cyan
