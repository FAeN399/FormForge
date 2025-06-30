#!/data/data/com.termux/files/usr/bin/bash

# Project generators for FormForge

# Main project generator
generate_project() {
    local template_type="$1"
    local app_name="$2"
    local package_name="$3"
    shift 3
    local extra_params=("$@")
    
    # Sanitize inputs
    local safe_app_name=$(sanitize_name "$app_name")
    local safe_package=$(to_package_name "$package_name")
    
    # Validate package name
    validate_package_name "$safe_package" || return 1
    
    # Create project directory
    local project_id=$(generate_project_id)
    local project_dir="$HOME/downloads/${safe_app_name}"
    generated_path="$project_dir"
    
    echo -e "\n${BLUE}Generating project...${NC}"
    
    # Create base structure
    create_project_structure "$project_dir" "$safe_package"
    
    # Generate based on template type
    case "$template_type" in
        "quick")
            generate_quick_template "$project_dir" "$safe_app_name" "$safe_package" "${extra_params[@]}"
            ;;
        "crud")
            generate_crud_template "$project_dir" "$safe_app_name" "$safe_package" "${extra_params[@]}"
            ;;
        "api")
            generate_api_template "$project_dir" "$safe_app_name" "$safe_package" "${extra_params[@]}"
            ;;
        *)
            echo -e "${RED}Unknown template type: $template_type${NC}"
            return 1
            ;;
    esac
    
    # Generate common files
    generate_common_files "$project_dir" "$safe_app_name" "$safe_package"
    
    # Add GitHub Actions
    add_github_actions "$project_dir"
    
    echo -e "${GREEN}✓ Project generated at: $project_dir${NC}"
}

# Create base Android project structure
create_project_structure() {
    local base_dir="$1"
    local package_name="$2"
    local package_path="${package_name//./\/}"
    
    # Create directories
    local dirs=(
        "$base_dir/app/src/main/java/$package_path"
        "$base_dir/app/src/main/res/layout"
        "$base_dir/app/src/main/res/values"
        "$base_dir/app/src/main/res/drawable"
        "$base_dir/app/src/main/res/mipmap-hdpi"
        "$base_dir/app/src/test/java/$package_path"
        "$base_dir/app/src/androidTest/java/$package_path"
        "$base_dir/gradle/wrapper"
        "$base_dir/.github/workflows"
    )
    
    for dir in "${dirs[@]}"; do
        create_dir "$dir"
    done
}

# Generate quick app template
generate_quick_template() {
    local project_dir="$1"
    local app_name="$2"
    local package_name="$3"
    local theme_choice="$4"
    local screen_choice="$5"
    
    # Determine theme
    local theme_name="Material3"
    case "$theme_choice" in
        2) theme_name="MaterialClassic" ;;
        3) theme_name="DarkOnly" ;;
    esac
    
    # Generate MainActivity based on screen choice
    local main_screen="ListScreen"
    case "$screen_choice" in
        2) main_screen="DashboardScreen" ;;
        3) main_screen="FormScreen" ;;
        4) main_screen="WebViewScreen" ;;
    esac
    
    # Create template variables
    declare -A vars=(
        [APP_NAME]="$app_name"
        [PACKAGE_NAME]="$package_name"
        [THEME_NAME]="$theme_name"
        [MAIN_SCREEN]="$main_screen"
        [ACTIVITY_NAME]="MainActivity"
    )
    
    # Generate MainActivity.kt
    cat > "$project_dir/app/src/main/java/${package_name//./\/}/MainActivity.kt" << EOF
package $package_name

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import ${package_name}.ui.theme.${app_name}Theme
import ${package_name}.ui.screens.$main_screen

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ${app_name}Theme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    $main_screen()
                }
            }
        }
    }
}
EOF

    # Generate screen based on choice
    generate_screen_template "$project_dir" "$package_name" "$main_screen" "$app_name"
}

# Generate screen templates
generate_screen_template() {
    local project_dir="$1"
    local package_name="$2"
    local screen_name="$3"
    local app_name="$4"
    
    local screen_dir="$project_dir/app/src/main/java/${package_name//./\/}/ui/screens"
    create_dir "$screen_dir"
    
    case "$screen_name" in
        "ListScreen")
            cat > "$screen_dir/ListScreen.kt" << 'EOF'
package {{PACKAGE_NAME}}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ListScreen() {
    var items by remember { mutableStateOf(listOf("Item 1", "Item 2", "Item 3")) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("{{APP_NAME}}") }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { 
                    items = items + "Item ${items.size + 1}"
                }
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add")
            }
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            items(items) { item ->
                Card(
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(
                        text = item,
                        modifier = Modifier.padding(16.dp),
                        style = MaterialTheme.typography.bodyLarge
                    )
                }
            }
        }
    }
}
EOF
            ;;
        "DashboardScreen")
            cat > "$screen_dir/DashboardScreen.kt" << 'EOF'
package {{PACKAGE_NAME}}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DashboardScreen() {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("{{APP_NAME}} Dashboard") }
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
            // Stats Cards
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(16.dp)
            ) {
                StatCard(
                    modifier = Modifier.weight(1f),
                    title = "Total",
                    value = "42"
                )
                StatCard(
                    modifier = Modifier.weight(1f),
                    title = "Active",
                    value = "17"
                )
            }
            
            // Recent Items
            Card(
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(
                    modifier = Modifier.padding(16.dp)
                ) {
                    Text(
                        text = "Recent Activity",
                        style = MaterialTheme.typography.titleMedium
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text("No recent activity")
                }
            }
        }
    }
}

@Composable
fun StatCard(
    modifier: Modifier = Modifier,
    title: String,
    value: String
) {
    Card(modifier = modifier) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = value,
                style = MaterialTheme.typography.headlineMedium
            )
            Text(
                text = title,
                style = MaterialTheme.typography.bodyMedium
            )
        }
    }
}
EOF
            ;;
    esac
    
    # Replace variables in the generated file
    local file="$screen_dir/${screen_name}.kt"
    sed -i "s/{{PACKAGE_NAME}}/$package_name/g" "$file"
    sed -i "s/{{APP_NAME}}/$app_name/g" "$file"
}

# Generate common project files
generate_common_files() {
    local project_dir="$1"
    local app_name="$2"
    local package_name="$3"
    
    # settings.gradle.kts
    cat > "$project_dir/settings.gradle.kts" << EOF
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "$app_name"
include(":app")
EOF

    # build.gradle.kts (root)
    cat > "$project_dir/build.gradle.kts" << 'EOF'
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.kotlin.compose) apply false
}
EOF

    # gradle.properties
    cat > "$project_dir/gradle.properties" << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.nonTransitiveRClass=true
kotlin.code.style=official
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
EOF

    # Create gradle wrapper properties
    cat > "$project_dir/gradle/wrapper/gradle-wrapper.properties" << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.10.2-bin.zip
networkTimeout=10000
validateDistributionUrl=true
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

    # Create version catalog
    create_version_catalog "$project_dir"
    
    # Create app build.gradle.kts
    create_app_build_gradle "$project_dir" "$app_name" "$package_name"
    
    # Create AndroidManifest.xml
    create_android_manifest "$project_dir" "$app_name" "$package_name"
    
    # Create basic resources
    create_basic_resources "$project_dir" "$app_name"
    
    # Create theme
    create_theme_files "$project_dir" "$package_name" "$app_name"
}

# Add GitHub Actions workflow
add_github_actions() {
    local project_dir="$1"
    
    cat > "$project_dir/.github/workflows/build.yml" << 'EOF'
name: Build APK

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up JDK 17
      uses: actions/setup-java@v4
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Setup Android SDK
      uses: android-actions/setup-android@v3
    
    - name: Grant execute permission for gradlew
      run: chmod +x gradlew
    
    - name: Build with Gradle
      run: ./gradlew assembleDebug
    
    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: app-debug
        path: app/build/outputs/apk/debug/app-debug.apk
    
    - name: Create Release
      if: github.event_name == 'push' && github.ref == 'refs/heads/main'
      uses: ncipollo/release-action@v1
      with:
        artifacts: "app/build/outputs/apk/debug/app-debug.apk"
        token: ${{ secrets.GITHUB_TOKEN }}
        tag: v1.0.${{ github.run_number }}
        name: "Release v1.0.${{ github.run_number }}"
        body: "Automated build from commit ${{ github.sha }}"
        allowUpdates: true
EOF

    # Create .gitignore
    cat > "$project_dir/.gitignore" << 'EOF'
*.iml
.gradle
/local.properties
/.idea
.DS_Store
/build
/captures
.externalNativeBuild
.cxx
*.apk
*.aab
*.ap_
*.dex
*.class
bin/
gen/
out/
proguard/
*.log
EOF
}

# Create version catalog
create_version_catalog() {
    local project_dir="$1"
    
    cat > "$project_dir/gradle/libs.versions.toml" << 'EOF'
[versions]
agp = "8.7.3"
kotlin = "2.0.21"
compose-bom = "2024.12.01"
lifecycle = "2.8.7"
navigation = "2.8.5"
junit = "4.13.2"

[libraries]
androidx-core-ktx = { group = "androidx.core", name = "core-ktx", version = "1.15.0" }
androidx-lifecycle-runtime-ktx = { group = "androidx.lifecycle", name = "lifecycle-runtime-ktx", version.ref = "lifecycle" }
androidx-activity-compose = { group = "androidx.activity", name = "activity-compose", version = "1.9.3" }
androidx-compose-bom = { group = "androidx.compose", name = "compose-bom", version.ref = "compose-bom" }
androidx-compose-ui = { group = "androidx.compose.ui", name = "ui" }
androidx-compose-ui-tooling = { group = "androidx.compose.ui", name = "ui-tooling" }
androidx-compose-ui-tooling-preview = { group = "androidx.compose.ui", name = "ui-tooling-preview" }
androidx-compose-material3 = { group = "androidx.compose.material3", name = "material3" }
androidx-navigation-compose = { group = "androidx.navigation", name = "navigation-compose", version.ref = "navigation" }
junit = { group = "junit", name = "junit", version.ref = "junit" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
kotlin-android = { id = "org.jetbrains.kotlin.android", version.ref = "kotlin" }
kotlin-compose = { id = "org.jetbrains.kotlin.plugin.compose", version.ref = "kotlin" }
EOF
}