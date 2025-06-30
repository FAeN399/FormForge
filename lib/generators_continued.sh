#!/data/data/com.termux/files/usr/bin/bash

# Continuation of generators.sh - Additional generator functions

# Create app build.gradle.kts
create_app_build_gradle() {
    local project_dir="$1"
    local app_name="$2"
    local package_name="$3"
    
    cat > "$project_dir/app/build.gradle.kts" << EOF
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
}

android {
    namespace = "$package_name"
    compileSdk = 35

    defaultConfig {
        applicationId = "$package_name"
        minSdk = 26
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = "17"
    }
    
    buildFeatures {
        compose = true
    }
    
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.compose.material3)
    implementation(libs.androidx.navigation.compose)
    testImplementation(libs.junit)
    debugImplementation(libs.androidx.compose.ui.tooling)
}
EOF

    # Create proguard rules
    touch "$project_dir/app/proguard-rules.pro"
}

# Create AndroidManifest.xml
create_android_manifest() {
    local project_dir="$1"
    local app_name="$2"
    local package_name="$3"
    
    cat > "$project_dir/app/src/main/AndroidManifest.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools">

    <application
        android:allowBackup="true"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:fullBackupContent="@xml/backup_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.$app_name"
        tools:targetApi="35">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.$app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
    </application>

</manifest>
EOF
}

# Create basic resources
create_basic_resources() {
    local project_dir="$1"
    local app_name="$2"
    
    # strings.xml
    cat > "$project_dir/app/src/main/res/values/strings.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$app_name</string>
</resources>
EOF

    # themes.xml
    cat > "$project_dir/app/src/main/res/values/themes.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.$app_name" parent="android:Theme.Material.Light.NoActionBar" />
</resources>
EOF

    # backup_rules.xml
    mkdir -p "$project_dir/app/src/main/res/xml"
    cat > "$project_dir/app/src/main/res/xml/backup_rules.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <include domain="sharedpref" path="."/>
    <exclude domain="sharedpref" path="device.xml"/>
</full-backup-content>
EOF

    # data_extraction_rules.xml
    cat > "$project_dir/app/src/main/res/xml/data_extraction_rules.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
    <cloud-backup>
        <include domain="sharedpref" path="."/>
        <exclude domain="sharedpref" path="device.xml"/>
    </cloud-backup>
</data-extraction-rules>
EOF

    # Create launcher icons
    create_launcher_icons "$project_dir" "$app_name"
}

# Create launcher icons
create_launcher_icons() {
    local project_dir="$1"
    local app_name="$2"
    
    # Create mipmap directories
    local densities=("mdpi" "hdpi" "xhdpi" "xxhdpi" "xxxhdpi")
    
    for density in "${densities[@]}"; do
        local dir="$project_dir/app/src/main/res/mipmap-$density"
        create_dir "$dir"
        
        # Create minimal PNG (1x1 pixel)
        printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15\xc4\x89\x00\x00\x00\rIDATx\xdac\xf8\x0f\x00\x00\x01\x01\x00\x00\x05\x00\x01\x0d\n-\xb4\x00\x00\x00\x00IEND\xaeB`\x82' > "$dir/ic_launcher.png"
        cp "$dir/ic_launcher.png" "$dir/ic_launcher_round.png"
    done
    
    # Create adaptive icon for API 26+
    local adaptive_dir="$project_dir/app/src/main/res/mipmap-anydpi-v26"
    create_dir "$adaptive_dir"
    
    cat > "$adaptive_dir/ic_launcher.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
EOF
    
    cp "$adaptive_dir/ic_launcher.xml" "$adaptive_dir/ic_launcher_round.xml"
    
    # Create vector drawable foreground
    cat > "$project_dir/app/src/main/res/drawable/ic_launcher_foreground.xml" << EOF
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M54,34 L54,74 M34,54 L74,54"
        android:strokeWidth="4"
        android:strokeColor="#FFFFFF"/>
</vector>
EOF

    # Add launcher background color
    if [ ! -f "$project_dir/app/src/main/res/values/colors.xml" ]; then
        cat > "$project_dir/app/src/main/res/values/colors.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#3F51B5</color>
</resources>
EOF
    fi
}

# Create theme files
create_theme_files() {
    local project_dir="$1"
    local package_name="$2"
    local app_name="$3"
    
    local theme_dir="$project_dir/app/src/main/java/${package_name//./\/}/ui/theme"
    create_dir "$theme_dir"
    
    # Theme.kt
    cat > "$theme_dir/Theme.kt" << EOF
package ${package_name}.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext

private val LightColorScheme = lightColorScheme()
private val DarkColorScheme = darkColorScheme()

@Composable
fun ${app_name}Theme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    dynamicColor: Boolean = true,
    content: @Composable () -> Unit
) {
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            val context = LocalContext.current
            if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        darkTheme -> DarkColorScheme
        else -> LightColorScheme
    }

    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}
EOF
}

# Generate CRUD template
generate_crud_template() {
    local project_dir="$1"
    local app_name="$2"
    local package_name="$3"
    local entity_name="$4"
    local db_choice="$5"
    
    # Generate data model
    local model_dir="$project_dir/app/src/main/java/${package_name//./\/}/data/model"
    create_dir "$model_dir"
    
    cat > "$model_dir/${entity_name}.kt" << EOF
package ${package_name}.data.model

data class $entity_name(
    val id: Long = 0,
    val title: String,
    val description: String = "",
    val createdAt: Long = System.currentTimeMillis(),
    val updatedAt: Long = System.currentTimeMillis()
)
EOF

    # Generate repository based on database choice
    local repo_dir="$project_dir/app/src/main/java/${package_name//./\/}/data/repository"
    create_dir "$repo_dir"
    
    if [ "$db_choice" == "1" ]; then
        # Room database
        generate_room_setup "$project_dir" "$package_name" "$entity_name"
    else
        # Simple in-memory repository
        cat > "$repo_dir/${entity_name}Repository.kt" << EOF
package ${package_name}.data.repository

import ${package_name}.data.model.$entity_name
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow

class ${entity_name}Repository {
    private val items = MutableStateFlow<List<$entity_name>>(emptyList())
    
    fun getAll(): Flow<List<$entity_name>> = items
    
    suspend fun insert(item: $entity_name) {
        items.value = items.value + item.copy(id = System.currentTimeMillis())
    }
    
    suspend fun update(item: $entity_name) {
        items.value = items.value.map { if (it.id == item.id) item else it }
    }
    
    suspend fun delete(item: $entity_name) {
        items.value = items.value.filter { it.id != item.id }
    }
}
EOF
    fi
    
    # Generate CRUD screens
    generate_crud_screens "$project_dir" "$package_name" "$entity_name" "$app_name"
}

# Generate CRUD screens
generate_crud_screens() {
    local project_dir="$1"
    local package_name="$2"
    local entity_name="$3"
    local app_name="$4"
    
    local screens_dir="$project_dir/app/src/main/java/${package_name//./\/}/ui/screens"
    create_dir "$screens_dir"
    
    # List screen
    cat > "$screens_dir/${entity_name}ListScreen.kt" << EOF
package ${package_name}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import ${package_name}.data.model.$entity_name

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ${entity_name}ListScreen(
    onAddClick: () -> Unit = {},
    onItemClick: ($entity_name) -> Unit = {}
) {
    var items by remember { mutableStateOf(listOf<$entity_name>()) }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("$app_name") }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = onAddClick
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add")
            }
        }
    ) { paddingValues ->
        if (items.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentAlignment = Alignment.Center
            ) {
                Text("No items yet. Tap + to add one!")
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(items) { item ->
                    Card(
                        onClick = { onItemClick(item) },
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Column(
                            modifier = Modifier.padding(16.dp)
                        ) {
                            Text(
                                text = item.title,
                                style = MaterialTheme.typography.titleMedium
                            )
                            if (item.description.isNotEmpty()) {
                                Text(
                                    text = item.description,
                                    style = MaterialTheme.typography.bodyMedium
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}
EOF

    # Edit screen
    cat > "$screens_dir/${entity_name}EditScreen.kt" << EOF
package ${package_name}.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import ${package_name}.data.model.$entity_name

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ${entity_name}EditScreen(
    item: $entity_name? = null,
    onSave: ($entity_name) -> Unit = {},
    onCancel: () -> Unit = {}
) {
    var title by remember { mutableStateOf(item?.title ?: "") }
    var description by remember { mutableStateOf(item?.description ?: "") }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(if (item == null) "New ${entity_name}" else "Edit ${entity_name}") },
                navigationIcon = {
                    IconButton(onClick = onCancel) {
                        Icon(Icons.Default.Close, contentDescription = "Cancel")
                    }
                },
                actions = {
                    TextButton(
                        onClick = {
                            if (title.isNotBlank()) {
                                onSave(
                                    (item ?: $entity_name(title = "", description = "")).copy(
                                        title = title,
                                        description = description
                                    )
                                )
                            }
                        }
                    ) {
                        Text("Save")
                    }
                }
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
            OutlinedTextField(
                value = title,
                onValueChange = { title = it },
                label = { Text("Title") },
                modifier = Modifier.fillMaxWidth()
            )
            
            OutlinedTextField(
                value = description,
                onValueChange = { description = it },
                label = { Text("Description") },
                modifier = Modifier.fillMaxWidth(),
                minLines = 3
            )
        }
    }
}
EOF
}

# Generate Room database setup
generate_room_setup() {
    local project_dir="$1"
    local package_name="$2"
    local entity_name="$3"
    
    # Add Room dependencies to build.gradle.kts
    echo "Note: Add Room dependencies to app/build.gradle.kts:"
    echo "implementation(\"androidx.room:room-runtime:2.6.1\")"
    echo "implementation(\"androidx.room:room-ktx:2.6.1\")"
    echo "ksp(\"androidx.room:room-compiler:2.6.1\")"
}

# Add source to generators.sh
echo "source \"\$LIB_DIR/generators_continued.sh\"" >> "$FORMFORGE_HOME/lib/generators.sh"