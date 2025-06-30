# FormForge - Android App Generator for Termux

Generate complete Android apps directly from your phone's terminal!

## 🚀 Features

- **Quick App Generation**: Create a working app in under 2 minutes
- **Mobile-Optimized**: Designed for one-handed terminal use
- **Smart Templates**: 8+ pre-built app patterns
- **GitHub Actions**: Automatic APK building
- **Zero Desktop Required**: Everything works in Termux

## 📱 Installation

```bash
# Clone FormForge
git clone https://github.com/yourusername/FormForge.git
cd FormForge

# Make executable
chmod +x formforge

# Add to PATH (optional)
echo "export PATH=\$PATH:$(pwd)" >> ~/.bashrc
source ~/.bashrc
```

## 🎯 Quick Start

1. Run FormForge:
```bash
./formforge
```

2. Choose "Quick App" (option 1)

3. Enter basic details:
   - App name: `MyFirstApp`
   - Package: `com.example.myapp`

4. Select theme and main screen type

5. Your app is generated! Next steps:
```bash
cd ~/downloads/MyFirstApp
git init && git add .
git commit -m "Initial commit"
# Push to GitHub for automatic build
```

## 📋 Available Templates

### 1. Quick App
Basic template with customizable main screen:
- List view with items
- Dashboard with metrics
- Form input screen
- WebView wrapper

### 2. CRUD App
Database-driven app with:
- Create, Read, Update, Delete operations
- Room database or simple storage
- List and detail screens

### 3. API Client
REST API integration with:
- Retrofit setup
- Authentication options
- Data models
- Error handling

### 4. Note Taking App
- Rich text editing
- Categories and tags
- Search functionality

### 5. Game Template
Simple game frameworks:
- Quiz game
- Memory game
- Puzzle mechanics
- Canvas drawing

### 6. More Templates
- Analytics Dashboard
- Chat UI
- Authentication Flow
- E-commerce
- News Reader
- Music Player

## 🛠️ Advanced Usage

### Custom Generator
For experienced developers:
```bash
./formforge
# Choose option 6 (Custom)
# Select architecture (MVVM/MVI/MVP)
# Choose dependencies
```

### Template Library
Browse and install community templates:
```bash
./formforge
# Choose option 7 (Templates Library)
# Select template to install
```

## 🏗️ Project Structure

Generated apps include:
```
MyApp/
├── app/
│   ├── src/main/java/      # Kotlin source code
│   ├── src/main/res/        # Resources
│   └── build.gradle.kts     # App build config
├── .github/workflows/       # GitHub Actions
├── gradle/                  # Gradle wrapper
└── README.md               # Project docs
```

## 🔄 Workflow

1. **Generate**: Create app structure in Termux
2. **Push**: Upload to GitHub
3. **Build**: GitHub Actions compiles APK
4. **Download**: Get APK from GitHub releases

## 🎨 Customization

### Adding Templates
Create new templates in `templates/` directory:
```bash
templates/mytemplate/
├── template.json
├── MainActivity.kt.template
└── layout.xml.template
```

### Modifying Generators
Edit files in `lib/`:
- `generators.sh`: Project generation logic
- `templates.sh`: Template management
- `utils.sh`: Helper functions

## 📱 Mobile-First Design

FormForge is optimized for mobile terminals:
- Short, memorable commands
- Minimal typing required
- Smart defaults
- Clear visual feedback
- One-handed operation friendly

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Add your template or feature
4. Submit a pull request

## 📄 License

MIT License - See LICENSE file

## 💡 Tips

- Use simple names without spaces
- Package format: `com.yourname.app`
- Keep GitHub token handy for pushing
- Generated apps use Material 3 design
- All apps support Android 8.0+

## 🐛 Troubleshooting

### Missing Dependencies
```bash
pkg install openjdk-21 gradle git
```

### Build Fails on GitHub
- Check Actions tab for logs
- Ensure all files were committed
- Verify package name format

### Can't Find Generated App
Apps are created in: `~/downloads/AppName/`

## 🎯 Examples

### Quick Blog App
```bash
./formforge
# 1 (Quick App)
# App name: BlogReader
# Package: com.myblog.reader
# Theme: 1 (Material You)
# Screen: 1 (List view)
```

### Todo List with Database
```bash
./formforge
# 2 (CRUD App)
# App name: TodoList
# Package: com.todo.app
# Entity: Task
# Database: 1 (Room)
```

### Weather API Client
```bash
./formforge
# 3 (API Client)
# App name: Weather
# Package: com.weather.app
# API URL: https://api.weather.com/v1
# Auth: 2 (API Key)
```

---

**Created with ❤️ for Termux developers**