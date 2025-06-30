#!/data/data/com.termux/files/usr/bin/bash

# Template management for FormForge

# Browse template library
browse_templates() {
    echo -e "\n${BLUE}${BOLD}Template Library${NC}"
    echo -e "${YELLOW}Browse and install community templates${NC}\n"
    
    local templates=(
        "1) 📊 Analytics Dashboard - Charts and data visualization"
        "2) 💬 Chat App - Real-time messaging UI"
        "3) 📷 Camera App - Photo capture and gallery"
        "4) 🗺️ Maps Integration - Location-based features"
        "5) 🔐 Auth Flow - Login/Register screens"
        "6) 🛒 E-commerce - Product listings and cart"
        "7) 📰 News Reader - Articles and categories"
        "8) 🎵 Music Player - Audio playback UI"
        "9) ⬅️  Back to main menu"
    )
    
    for template in "${templates[@]}"; do
        echo "$template"
    done
    
    echo ""
    read -p "Select template [1-9]: " choice
    
    case $choice in
        1) install_template "analytics" ;;
        2) install_template "chat" ;;
        3) install_template "camera" ;;
        4) install_template "maps" ;;
        5) install_template "auth" ;;
        6) install_template "ecommerce" ;;
        7) install_template "news" ;;
        8) install_template "music" ;;
        9) return ;;
        *) echo -e "${RED}Invalid choice${NC}" ;;
    esac
}

# Install a template
install_template() {
    local template_name="$1"
    
    echo -e "\n${BLUE}Installing $template_name template...${NC}"
    
    # Create template directory
    local template_dir="$TEMPLATES_DIR/$template_name"
    create_dir "$template_dir"
    
    # Generate template files based on type
    case "$template_name" in
        "analytics")
            create_analytics_template "$template_dir"
            ;;
        "chat")
            create_chat_template "$template_dir"
            ;;
        "auth")
            create_auth_template "$template_dir"
            ;;
        *)
            echo -e "${YELLOW}Template $template_name coming soon!${NC}"
            ;;
    esac
    
    echo -e "${GREEN}✓ Template installed!${NC}"
    sleep 2
}

# Create analytics dashboard template
create_analytics_template() {
    local template_dir="$1"
    
    # Template metadata
    cat > "$template_dir/template.json" << 'EOF'
{
  "name": "Analytics Dashboard",
  "description": "Data visualization with charts and metrics",
  "version": "1.0.0",
  "author": "FormForge",
  "requires": ["compose-charts"],
  "files": [
    "screens/DashboardScreen.kt",
    "screens/ChartsScreen.kt",
    "components/LineChart.kt",
    "components/PieChart.kt",
    "data/AnalyticsRepository.kt"
  ]
}
EOF

    # Dashboard screen template
    cat > "$template_dir/DashboardScreen.kt.template" << 'EOF'
package {{PACKAGE_NAME}}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import {{PACKAGE_NAME}}.ui.components.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DashboardScreen() {
    val metrics = remember {
        listOf(
            Metric("Users", "1,234", "+12%"),
            Metric("Revenue", "$45.6K", "+8%"),
            Metric("Orders", "89", "+23%"),
            Metric("Conversion", "3.2%", "-2%")
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Analytics Dashboard") }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Metrics Grid
            MetricsGrid(metrics = metrics)
            
            // Charts
            Card(
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "Revenue Trend",
                        style = MaterialTheme.typography.titleMedium
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    // LineChart component would go here
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(200.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Text("Chart Placeholder")
                    }
                }
            }
        }
    }
}

@Composable
fun MetricsGrid(metrics: List<Metric>) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        metrics.chunked(2).forEach { rowMetrics ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                rowMetrics.forEach { metric ->
                    MetricCard(
                        metric = metric,
                        modifier = Modifier.weight(1f)
                    )
                }
                if (rowMetrics.size == 1) {
                    Spacer(modifier = Modifier.weight(1f))
                }
            }
        }
    }
}

@Composable
fun MetricCard(
    metric: Metric,
    modifier: Modifier = Modifier
) {
    Card(modifier = modifier) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = metric.label,
                style = MaterialTheme.typography.labelMedium
            )
            Text(
                text = metric.value,
                style = MaterialTheme.typography.headlineSmall
            )
            Text(
                text = metric.change,
                style = MaterialTheme.typography.bodySmall,
                color = if (metric.change.startsWith("+")) 
                    MaterialTheme.colorScheme.primary 
                else 
                    MaterialTheme.colorScheme.error
            )
        }
    }
}

data class Metric(
    val label: String,
    val value: String,
    val change: String
)
EOF
}

# Create chat app template
create_chat_template() {
    local template_dir="$1"
    
    cat > "$template_dir/template.json" << 'EOF'
{
  "name": "Chat App",
  "description": "Real-time messaging UI with conversation list",
  "version": "1.0.0",
  "author": "FormForge",
  "files": [
    "screens/ConversationListScreen.kt",
    "screens/ChatScreen.kt",
    "components/MessageBubble.kt",
    "data/Message.kt"
  ]
}
EOF

    # Chat screen template
    cat > "$template_dir/ChatScreen.kt.template" << 'EOF'
package {{PACKAGE_NAME}}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Send
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatScreen(
    contactName: String = "John Doe"
) {
    var messageText by remember { mutableStateOf("") }
    var messages by remember { 
        mutableStateOf(
            listOf(
                Message("Hello!", false),
                Message("Hi there! How are you?", true),
                Message("I'm doing great, thanks!", false)
            )
        )
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(contactName) }
            )
        },
        bottomBar = {
            Surface(
                modifier = Modifier.fillMaxWidth(),
                color = MaterialTheme.colorScheme.surface,
                tonalElevation = 3.dp
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(8.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    TextField(
                        value = messageText,
                        onValueChange = { messageText = it },
                        modifier = Modifier.weight(1f),
                        placeholder = { Text("Type a message") },
                        colors = TextFieldDefaults.colors()
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    IconButton(
                        onClick = {
                            if (messageText.isNotBlank()) {
                                messages = messages + Message(messageText, true)
                                messageText = ""
                            }
                        }
                    ) {
                        Icon(Icons.Default.Send, contentDescription = "Send")
                    }
                }
            }
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
            reverseLayout = true
        ) {
            items(messages.reversed()) { message ->
                MessageBubble(
                    message = message,
                    isFromMe = message.isFromMe
                )
            }
        }
    }
}

@Composable
fun MessageBubble(
    message: Message,
    isFromMe: Boolean
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isFromMe) Arrangement.End else Arrangement.Start
    ) {
        Card(
            colors = CardDefaults.cardColors(
                containerColor = if (isFromMe)
                    MaterialTheme.colorScheme.primary
                else
                    MaterialTheme.colorScheme.surfaceVariant
            ),
            modifier = Modifier.widthIn(max = 280.dp)
        ) {
            Text(
                text = message.text,
                modifier = Modifier.padding(12.dp),
                color = if (isFromMe)
                    MaterialTheme.colorScheme.onPrimary
                else
                    MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}

data class Message(
    val text: String,
    val isFromMe: Boolean,
    val timestamp: Long = System.currentTimeMillis()
)
EOF
}

# Create auth flow template
create_auth_template() {
    local template_dir="$1"
    
    cat > "$template_dir/template.json" << 'EOF'
{
  "name": "Authentication Flow",
  "description": "Login, register, and password reset screens",
  "version": "1.0.0",
  "author": "FormForge",
  "files": [
    "screens/LoginScreen.kt",
    "screens/RegisterScreen.kt",
    "screens/ForgotPasswordScreen.kt",
    "viewmodel/AuthViewModel.kt"
  ]
}
EOF

    # Login screen template
    cat > "$template_dir/LoginScreen.kt.template" << 'EOF'
package {{PACKAGE_NAME}}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp

@Composable
fun LoginScreen(
    onLoginClick: (String, String) -> Unit = { _, _ -> },
    onRegisterClick: () -> Unit = {},
    onForgotPasswordClick: () -> Unit = {}
) {
    var email by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var passwordVisible by remember { mutableStateOf(false) }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Welcome Back",
            style = MaterialTheme.typography.headlineLarge
        )
        
        Spacer(modifier = Modifier.height(32.dp))
        
        OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("Email") },
            leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
            modifier = Modifier.fillMaxWidth()
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Password") },
            leadingIcon = { Icon(Icons.Default.Lock, contentDescription = null) },
            trailingIcon = {
                IconButton(onClick = { passwordVisible = !passwordVisible }) {
                    Icon(
                        imageVector = if (passwordVisible) 
                            Icons.Default.Visibility 
                        else 
                            Icons.Default.VisibilityOff,
                        contentDescription = "Toggle password visibility"
                    )
                }
            },
            visualTransformation = if (passwordVisible) 
                VisualTransformation.None 
            else 
                PasswordVisualTransformation(),
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
            modifier = Modifier.fillMaxWidth()
        )
        
        Spacer(modifier = Modifier.height(8.dp))
        
        TextButton(
            onClick = onForgotPasswordClick,
            modifier = Modifier.align(Alignment.End)
        ) {
            Text("Forgot Password?")
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        Button(
            onClick = { onLoginClick(email, password) },
            modifier = Modifier.fillMaxWidth(),
            enabled = email.isNotBlank() && password.isNotBlank()
        ) {
            Text("Login")
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        Row(
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text("Don't have an account?")
            TextButton(onClick = onRegisterClick) {
                Text("Register")
            }
        }
    }
}
EOF
}

# Generate note taking app
generate_note_app() {
    echo -e "\n${BLUE}${BOLD}Note Taking App Generator${NC}"
    
    read -p "App name: " app_name
    app_name=${app_name:-NoteApp}
    
    read -p "Package name: " package_name
    package_name=${package_name:-com.example.notes}
    
    echo ""
    echo "Features:"
    echo "1) Basic (Title + Content)"
    echo "2) Rich Text (Formatting)"
    echo "3) Advanced (Tags, Categories)"
    read -p "Choose [1-3]: " feature_level
    
    generate_project "notes" "$app_name" "$package_name" "$feature_level"
}

# Generate game template
generate_game_template() {
    echo -e "\n${BLUE}${BOLD}Game Template Generator${NC}"
    
    read -p "App name: " app_name
    read -p "Package name: " package_name
    
    echo ""
    echo "Game type:"
    echo "1) Quiz Game"
    echo "2) Memory Game"
    echo "3) Puzzle"
    echo "4) Canvas Drawing"
    read -p "Choose [1-4]: " game_type
    
    generate_project "game" "$app_name" "$package_name" "$game_type"
}

# Custom generator
custom_generator() {
    echo -e "\n${BLUE}${BOLD}Custom App Generator${NC}"
    echo -e "${YELLOW}Advanced options for experienced developers${NC}\n"
    
    read -p "App name: " app_name
    read -p "Package name: " package_name
    
    echo ""
    echo "Architecture:"
    echo "1) MVVM (Recommended)"
    echo "2) MVI"
    echo "3) MVP"
    read -p "Choose [1-3]: " arch_choice
    
    echo ""
    echo "Dependencies to include:"
    echo "[x] Jetpack Compose"
    echo "[ ] Hilt (y/n): " && read -p "" include_hilt
    echo "[ ] Retrofit (y/n): " && read -p "" include_retrofit
    echo "[ ] Room (y/n): " && read -p "" include_room
    echo "[ ] Coroutines Flow (y/n): " && read -p "" include_flow
    
    # Generate with custom options
    generate_custom_project "$app_name" "$package_name" "$arch_choice" \
        "$include_hilt" "$include_retrofit" "$include_room" "$include_flow"
}

# Show help
show_help() {
    clear
    echo -e "${BLUE}${BOLD}FormForge Help${NC}"
    echo ""
    echo -e "${GREEN}Quick Start:${NC}"
    echo "1. Choose 'Quick App' for fastest setup"
    echo "2. Enter app name and package"
    echo "3. Select theme and main screen"
    echo "4. Push to GitHub for automatic build"
    echo ""
    echo -e "${GREEN}Tips:${NC}"
    echo "• Use simple names without spaces"
    echo "• Package format: com.yourname.app"
    echo "• All projects include GitHub Actions"
    echo "• Templates are customizable"
    echo ""
    echo -e "${GREEN}Workflow:${NC}"
    echo "Generate → Push → Build → Download"
    echo ""
    read -p "Press Enter to continue..."
}