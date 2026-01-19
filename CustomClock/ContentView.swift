import SwiftUI
import Combine
import UniformTypeIdentifiers
import AppKit

extension Color {
    static let themeBlack = Color(red: 0.07, green: 0.07, blue: 0.07)
    static let themeDarkGray = Color(red: 0.11, green: 0.11, blue: 0.11)
    static let themeGray = Color(red: 0.15, green: 0.15, blue: 0.15)
    static let themeLightGray = Color(red: 0.18, green: 0.18, blue: 0.18)
    static let themeGreen = Color(red: 0.12, green: 0.84, blue: 0.38)
    static let themeText = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let themeTextBright = Color(red: 0.95, green: 0.95, blue: 0.95)
}

struct ContentView: View {
    @State private var backgroundImage: NSImage?
    @State private var imageScale: Double = 1.0
    @State private var imageOffsetX: Double = 0
    @State private var imageOffsetY: Double = 0
    
    @State private var showBorder: Bool = false
    @State private var borderColor: Color = .white
    @State private var borderWidth: Double = 2.0
    @State private var showDayNumber: Bool = false
    @State private var dayNumberSize: Double = 40
    @State private var dayNumberOffsetX: Double = 0
    @State private var dayNumberOffsetY: Double = 60
    @State private var dayNumberFont: DayFont = .rounded
    @State private var dayNumberColor: Color = .white
    @State private var hourHandColor: Color = .white
    @State private var minuteHandColor: Color = .white
    @State private var secondHandColor: Color = .red
    @State private var handStyle: HandStyle = .modern
    private let settingsManager = WidgetSettingsManager()
    @State private var isButtonHovered = false
    @State private var selectedSection: Int? = 0
    @State private var widgetWindows: [WidgetWindow] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.themeBlack, Color(red: 0.05, green: 0.05, blue: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.themeGreen.opacity(0.8), Color.themeGreen.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "clock.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Clock Studio")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.themeText)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 4) {
                        SidebarItem(icon: "house.fill", label: "Home", isSelected: selectedSection == 0) {
                            selectedSection = 0
                        }
                        SidebarItem(icon: "clock", label: "Widget", isSelected: selectedSection == 1) {
                            selectedSection = 1
                        }
                        SidebarItem(icon: "gearshape", label: "Settings", isSelected: selectedSection == 2) {
                            selectedSection = 2
                        }
                    }
                    .padding(.horizontal, 12)
                    
                    Spacer()
                    
                    Text("v1.0.0")
                        .font(.system(size: 10))
                        .foregroundColor(.themeText.opacity(0.5))
                        .padding(.bottom, 16)
                }
                .frame(width: 80)
                .background(Color.themeDarkGray)
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Widget Designer")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.themeTextBright)
                            Text("Create your custom clock")
                                .font(.system(size: 13))
                                .foregroundColor(.themeText)
                        }
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.themeGreen)
                                .frame(width: 6, height: 6)
                            Text("PREVIEW")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.themeGreen)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.themeGreen.opacity(0.15))
                        .cornerRadius(20)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    
                    // Preview area
                    ZStack {
                        // Subtle glow behind preview (ottimizzato)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.themeGreen.opacity(0.06), Color.clear],
                                    center: .center,
                                    startRadius: 100,
                                    endRadius: 250
                                )
                            )
                            .frame(width: 400, height: 400)
                        
                        DraggablePreview(
                            backgroundImage: backgroundImage,
                            imageScale: imageScale,
                            imageOffsetX: imageOffsetX,
                            imageOffsetY: imageOffsetY,
                            showBorder: showBorder,
                            borderColor: borderColor,
                            borderWidth: borderWidth,
                            showDayNumber: showDayNumber,
                            dayNumberSize: dayNumberSize,
                            dayNumberOffsetX: $dayNumberOffsetX,
                            dayNumberOffsetY: $dayNumberOffsetY,
                            dayNumberFont: dayNumberFont,
                            dayNumberColor: dayNumberColor,
                            hourHandColor: hourHandColor,
                            minuteHandColor: minuteHandColor,
                            secondHandColor: secondHandColor,
                            handStyle: handStyle
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Button(action: { createWidgetWindow() }) {
                        HStack(spacing: 10) {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                            Text("Create Widget")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color.themeGreen)
                                .shadow(color: Color.themeGreen.opacity(isButtonHovered ? 0.5 : 0.3), radius: isButtonHovered ? 12 : 8)
                        )
                        .scaleEffect(isButtonHovered ? 1.02 : 1.0)
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isButtonHovered = hovering
                        }
                    }
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Customize")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.themeTextBright)
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        ThemeCard(title: "Background", icon: "photo.fill", iconColor: .orange) {
                            VStack(spacing: 14) {
                                Button(action: { selectBackgroundImage() }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: backgroundImage == nil ? "plus" : "arrow.triangle.2.circlepath")
                                            .font(.system(size: 12, weight: .semibold))
                                        Text(backgroundImage == nil ? "Add image" : "Change image")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(.themeTextBright)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.themeLightGray)
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                                if backgroundImage != nil {
                                    VStack(spacing: 12) {
                                        ThemeSlider(label: "Zoom", value: $imageScale, range: 0.5...2.0, icon: "magnifyingglass")
                                        ThemeSlider(label: "Position X", value: $imageOffsetX, range: -100...100, icon: "arrow.left.and.right")
                                        ThemeSlider(label: "Position Y", value: $imageOffsetY, range: -100...100, icon: "arrow.up.and.down")
                                    }
                                }
                            }
                        }
                        ThemeCard(title: "Border", icon: "square.dashed", iconColor: .cyan) {
                            VStack(spacing: 14) {
                                ThemeToggle(label: "Show border", isOn: $showBorder)
                                if showBorder {
                                    ThemeColorPicker(label: "Color", selection: $borderColor)
                                    ThemeSlider(label: "Width", value: $borderWidth, range: 1...6, icon: "lineweight")
                                }
                            }
                        }
                        ThemeCard(title: "Date", icon: "calendar", iconColor: .purple) {
                            VStack(spacing: 14) {
                                ThemeToggle(label: "Show day", isOn: $showDayNumber)
                                if showDayNumber {
                                    ThemePicker(label: "Font", selection: $dayNumberFont) {
                                        Text("Rounded").tag(DayFont.rounded)
                                        Text("Serif").tag(DayFont.serif)
                                        Text("Mono").tag(DayFont.monospaced)
                                    }
                                    ThemeColorPicker(label: "Color", selection: $dayNumberColor)
                                    ThemeSlider(label: "Size", value: $dayNumberSize, range: 20...80, icon: "textformat.size")
                                    ThemeSlider(label: "Offset X", value: $dayNumberOffsetX, range: -100...100, icon: "arrow.left.and.right")
                                    ThemeSlider(label: "Offset Y", value: $dayNumberOffsetY, range: -100...100, icon: "arrow.up.and.down")
                                }
                            }
                        }
                        ThemeCard(title: "Hands", icon: "clock", iconColor: .themeGreen) {
                            VStack(spacing: 14) {
                                ThemePicker(label: "Style", selection: $handStyle) {
                                    Text("Modern").tag(HandStyle.modern)
                                    Text("Classic").tag(HandStyle.classic)
                                    Text("Thin").tag(HandStyle.thin)
                                }
                                Divider()
                                    .background(Color.white.opacity(0.06))
                                ThemeColorPicker(label: "Hour", selection: $hourHandColor)
                                ThemeColorPicker(label: "Minute", selection: $minuteHandColor)
                                ThemeColorPicker(label: "Second", selection: $secondHandColor)
                            }
                        }
                    }
                    .padding(20)
                }
                .frame(width: 300)
                .background(Color.themeDarkGray)
            }
        }
        .frame(width: 1200, height: 800)
        .onAppear {
            loadSettings()
        }
        .onChange(of: imageScale) { saveSettings() }
        .onChange(of: imageOffsetX) { saveSettings() }
        .onChange(of: imageOffsetY) { saveSettings() }
        .onChange(of: showBorder) { saveSettings() }
        .onChange(of: borderColor) { saveSettings() }
        .onChange(of: borderWidth) { saveSettings() }
        .onChange(of: showDayNumber) { saveSettings() }
        .onChange(of: dayNumberSize) { saveSettings() }
        .onChange(of: dayNumberOffsetX) { saveSettings() }
        .onChange(of: dayNumberOffsetY) { saveSettings() }
        .onChange(of: dayNumberFont) { saveSettings() }
        .onChange(of: dayNumberColor) { saveSettings() }
        .onChange(of: hourHandColor) { saveSettings() }
        .onChange(of: minuteHandColor) { saveSettings() }
        .onChange(of: secondHandColor) { saveSettings() }
        .onChange(of: handStyle) { saveSettings() }
    }
    
    
    func selectBackgroundImage() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.image]
        if panel.runModal() == .OK, let url = panel.url {
            if let image = NSImage(contentsOf: url) {
                withAnimation { backgroundImage = image }
                settingsManager.saveBackgroundImagePath(url.path)
            }
        }
    }
    
    func loadSettings() {
        if let settings = settingsManager.loadSettings() {
            imageScale = settings.imageScale
            imageOffsetX = settings.imageOffsetX
            imageOffsetY = settings.imageOffsetY
            showBorder = settings.showBorder
            borderColor = settings.borderColor.toColor()
            borderWidth = settings.borderWidth
            dayNumberSize = settings.dayNumberSize
            dayNumberOffsetX = settings.dayNumberOffsetX
            dayNumberOffsetY = settings.dayNumberOffsetY
            dayNumberFont = settings.dayNumberFont
            dayNumberColor = settings.dayNumberColor.toColor()
            hourHandColor = settings.hourHandColor.toColor()
            minuteHandColor = settings.minuteHandColor.toColor()
            secondHandColor = settings.secondHandColor.toColor()
            handStyle = settings.handStyle
            if let imagePath = settingsManager.loadBackgroundImagePath(),
               let image = NSImage(contentsOfFile: imagePath) {
                backgroundImage = image
            }
        }
    }
    
    func saveSettings() {
        let settings = WidgetSettings(
            imageScale: imageScale,
            imageOffsetX: imageOffsetX,
            imageOffsetY: imageOffsetY,
            showBorder: showBorder,
            borderColor: borderColor,
            borderWidth: borderWidth,
            showDayNumber: showDayNumber,
            dayNumberSize: dayNumberSize,
            dayNumberOffsetX: dayNumberOffsetX,
            dayNumberOffsetY: dayNumberOffsetY,
            dayNumberFont: dayNumberFont,
            dayNumberColor: dayNumberColor,
            hourHandColor: hourHandColor,
            minuteHandColor: minuteHandColor,
            secondHandColor: secondHandColor,
            handStyle: handStyle
        )
        settingsManager.saveSettings(settings)
    }
    
    func createWidgetWindow() {
        // Salva le impostazioni attuali prima di creare il widget
        saveSettings()
        
        // Crea il widget con i valori correnti
        let widgetWindow = WidgetWindow(
            backgroundImage: backgroundImage,
            imageScale: imageScale,
            imageOffsetX: imageOffsetX,
            imageOffsetY: imageOffsetY,
            showBorder: showBorder,
            borderColor: borderColor,
            borderWidth: borderWidth,
            showDayNumber: showDayNumber,
            dayNumberSize: dayNumberSize,
            dayNumberOffsetX: dayNumberOffsetX,
            dayNumberOffsetY: dayNumberOffsetY,
            dayNumberFont: dayNumberFont,
            dayNumberColor: dayNumberColor,
            hourHandColor: hourHandColor,
            minuteHandColor: minuteHandColor,
            secondHandColor: secondHandColor,
            handStyle: handStyle
        )
        
        // Mantieni riferimento per evitare deallocation
        widgetWindows.append(widgetWindow)
        widgetWindow.makeKeyAndOrderFront(nil)
    }
}

// MARK: - Spotify Style Components

struct SidebarItem: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .themeGreen : (isHovered ? .themeTextBright : .themeText))
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(isSelected ? .themeGreen : (isHovered ? .themeTextBright : .themeText))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.themeGreen.opacity(0.15) : (isHovered ? Color.white.opacity(0.05) : Color.clear))
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}

struct ThemeCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    @State private var isExpanded = true
    
    init(title: String, icon: String, iconColor: Color = .themeGreen, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(iconColor.opacity(0.15))
                            .frame(width: 28, height: 28)
                        Image(systemName: icon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(iconColor)
                    }
                    
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.themeTextBright)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.themeText)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            
            // Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.06))
                    
                    VStack(spacing: 12) {
                        content
                    }
                    .padding(14)
                }
            }
        }
        .background(Color.themeGray)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
}

struct ThemeSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 10))
                    .foregroundColor(.themeText)
                    .frame(width: 14)
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.themeText)
                Spacer()
                Text(String(format: "%.1f", value))
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.themeText.opacity(0.7))
            }
            
            Slider(value: $value, in: range)
                .accentColor(.themeGreen)
        }
    }
}

struct ThemeToggle: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.themeTextBright)
        }
        .toggleStyle(SwitchToggleStyle(tint: .themeGreen))
    }
}

struct ThemeColorPicker: View {
    let label: String
    @Binding var selection: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.themeText)
            Spacer()
            ColorPicker("", selection: $selection)
                .labelsHidden()
                .scaleEffect(0.8)
        }
    }
}

struct ThemePicker<SelectionValue: Hashable, Content: View>: View {
    let label: String
    @Binding var selection: SelectionValue
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.themeText)
            Spacer()
            Picker("", selection: $selection) {
                content()
            }
            .pickerStyle(.menu)
            .accentColor(.themeGreen)
            .scaleEffect(0.9)
        }
    }
}

enum DayFont: Codable {
    case rounded, serif, monospaced
}

enum HandStyle: Codable {
    case modern, classic, thin
}

struct DraggablePreview: View {
    let backgroundImage: NSImage?
    let imageScale: Double
    let imageOffsetX: Double
    let imageOffsetY: Double
    let showBorder: Bool
    let borderColor: Color
    let borderWidth: Double
    let showDayNumber: Bool
    let dayNumberSize: Double
    @Binding var dayNumberOffsetX: Double
    @Binding var dayNumberOffsetY: Double
    let dayNumberFont: DayFont
    let dayNumberColor: Color
    let hourHandColor: Color
    let minuteHandColor: Color
    let secondHandColor: Color
    let handStyle: HandStyle
    
    @State private var dragOffset = CGSize.zero
    @State private var isHovered = false
    @State private var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ZStack {
                if let image = backgroundImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(imageScale)
                        .offset(x: imageOffsetX, y: imageOffsetY)
                        .frame(width: 340, height: 340)
                        .clipped()
                        .cornerRadius(34)
                        .overlay(
                            RoundedRectangle(cornerRadius: 34)
                                .stroke(showBorder ? borderColor : Color.clear, lineWidth: showBorder ? borderWidth : 0)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.15, blue: 0.2),
                                    Color(red: 0.1, green: 0.1, blue: 0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 340, height: 340)
                        .overlay(
                            RoundedRectangle(cornerRadius: 34)
                                .stroke(showBorder ? borderColor : Color.white.opacity(0.08), lineWidth: showBorder ? borderWidth : 1)
                        )
                }
                
                ClockHandsView(
                    time: currentTime,
                    hourColor: hourHandColor,
                    minuteColor: minuteHandColor,
                    secondColor: secondHandColor,
                    style: handStyle
                )
                .allowsHitTesting(false)
                
                if showDayNumber {
                    DayNumberView(
                        size: dayNumberSize * (240 / 380),
                        offsetX: dayNumberOffsetX * (240 / 380),
                        offsetY: dayNumberOffsetY * (240 / 380),
                        font: dayNumberFont,
                        color: dayNumberColor
                    )
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                dayNumberOffsetX += value.translation.width / (240 / 380)
                                dayNumberOffsetY += value.translation.height / (240 / 380)
                                dragOffset = .zero
                            }
                    )
                }
            }
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .scaleEffect(isHovered ? 1.01 : 1.0)
            .animation(.easeOut(duration: 0.2), value: isHovered)
        }
        .frame(width: 380, height: 380)
        .onHover { hovering in
            isHovered = hovering
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}

class WidgetWindow: NSWindow {
    init(backgroundImage: NSImage?, imageScale: Double, imageOffsetX: Double, imageOffsetY: Double,
         showBorder: Bool, borderColor: Color, borderWidth: Double,
         showDayNumber: Bool, dayNumberSize: Double, dayNumberOffsetX: Double, dayNumberOffsetY: Double,
         dayNumberFont: DayFont, dayNumberColor: Color, hourHandColor: Color, minuteHandColor: Color, secondHandColor: Color, handStyle: HandStyle) {
        super.init(
            contentRect: NSRect(x: 200, y: 200, width: 240, height: 240),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces]
        self.isMovableByWindowBackground = true
        self.hasShadow = true
        
        let hostingView = NSHostingView(
            rootView: WidgetView(
                backgroundImage: backgroundImage,
                imageScale: imageScale,
                imageOffsetX: imageOffsetX,
                imageOffsetY: imageOffsetY,
                showBorder: showBorder,
                borderColor: borderColor,
                borderWidth: borderWidth,
                showDayNumber: showDayNumber,
                dayNumberSize: dayNumberSize,
                dayNumberOffsetX: dayNumberOffsetX,
                dayNumberOffsetY: dayNumberOffsetY,
                dayNumberFont: dayNumberFont,
                dayNumberColor: dayNumberColor,
                hourHandColor: hourHandColor,
                minuteHandColor: minuteHandColor,
                secondHandColor: secondHandColor,
                handStyle: handStyle,
                windowToClose: self
            )
        )
        self.contentView = hostingView
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    override var canBecomeMain: Bool {
        return false
    }
}

struct WidgetView: View {
    let backgroundImage: NSImage?
    let imageScale: Double
    let imageOffsetX: Double
    let imageOffsetY: Double
    let showBorder: Bool
    let borderColor: Color
    let borderWidth: Double
    let showDayNumber: Bool
    let dayNumberSize: Double
    let dayNumberOffsetX: Double
    let dayNumberOffsetY: Double
    let dayNumberFont: DayFont
    let dayNumberColor: Color
    let hourHandColor: Color
    let minuteHandColor: Color
    let secondHandColor: Color
    let handStyle: HandStyle
    weak var windowToClose: NSWindow?
    
    @State private var currentTime = Date()
    @State private var isHovering = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.clear
            
            // Background con orologio - centrato
            ZStack {
                if let image = backgroundImage {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(imageScale)
                        .offset(x: imageOffsetX, y: imageOffsetY)
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(showBorder ? borderColor : Color.clear, lineWidth: showBorder ? borderWidth : 0)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 200, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(showBorder ? borderColor : Color.clear, lineWidth: showBorder ? borderWidth : 0)
                        )
                }
                
                if isHovering {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 200, height: 200)
                }
                
                ClockHandsView(
                    time: currentTime,
                    hourColor: hourHandColor,
                    minuteColor: minuteHandColor,
                    secondColor: secondHandColor,
                    style: handStyle
                )
            }
            .frame(width: 200, height: 200)
            
            // Day number overlay - posizionato liberamente
            if showDayNumber {
                Text("\(Calendar.current.component(.day, from: Date()))")
                    .font(fontForDayNumber(dayNumberFont, dayNumberSize))
                    .foregroundColor(dayNumberColor)
                    .shadow(color: .black.opacity(0.5), radius: 3)
                    .offset(x: dayNumberOffsetX, y: dayNumberOffsetY)
                    .zIndex(100)
            }
        }
        .frame(width: 240, height: 240)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .contextMenu {
            Button(action: {
                windowToClose?.close()
            }) {
                Label("Delete widget", systemImage: "trash")
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
    
    func fontForDayNumber(_ font: DayFont, _ size: Double) -> Font {
        switch font {
        case .rounded:
            return .system(size: size, weight: .bold, design: .rounded)
        case .serif:
            return .system(size: size, weight: .bold, design: .serif)
        case .monospaced:
            return .system(size: size, weight: .bold, design: .monospaced)
        }
    }
}

struct DayNumberView: View {
    let size: Double
    let offsetX: Double
    let offsetY: Double
    let font: DayFont
    let color: Color
    
    var dayNumber: Int {
        Calendar.current.component(.day, from: Date())
    }
    
    var body: some View {
        Text("\(dayNumber)")
            .font(fontForStyle())
            .foregroundColor(color)
            .shadow(color: .black.opacity(0.5), radius: 3)
            .offset(x: offsetX, y: offsetY)
    }
    
    func fontForStyle() -> Font {
        switch font {
        case .rounded:
            return .system(size: size, weight: .bold, design: .rounded)
        case .serif:
            return .system(size: size, weight: .bold, design: .serif)
        case .monospaced:
            return .system(size: size, weight: .bold, design: .monospaced)
        }
    }
}

struct ClockHandsView: View {
    let time: Date
    let hourColor: Color
    let minuteColor: Color
    let secondColor: Color
    let style: HandStyle
    
    var body: some View {
        ZStack {
            HourHand(time: time, color: hourColor, style: style)
            MinuteHand(time: time, color: minuteColor, style: style)
            SecondHand(time: time, color: secondColor, style: style)
            
            Circle()
                .fill(Color.white)
                .frame(width: style == .thin ? 8 : 10, height: style == .thin ? 8 : 10)
                .shadow(color: .black.opacity(0.3), radius: 2)
        }
    }
}

struct HourHand: View {
    let time: Date
    let color: Color
    let style: HandStyle
    
    var hourAngle: Double {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: time) % 12)
        let minute = Double(calendar.component(.minute, from: time))
        return (hour + minute / 60) * 30 - 90
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: style == .thin ? 1 : 3)
            .fill(color)
            .frame(width: style == .thin ? 4 : (style == .classic ? 7 : 6), height: style == .thin ? 45 : 50)
            .shadow(color: .black.opacity(0.4), radius: 2)
            .offset(y: style == .thin ? -22.5 : -25)
            .rotationEffect(.degrees(hourAngle))
    }
}

struct MinuteHand: View {
    let time: Date
    let color: Color
    let style: HandStyle
    
    var minuteAngle: Double {
        let calendar = Calendar.current
        let minute = Double(calendar.component(.minute, from: time))
        let second = Double(calendar.component(.second, from: time))
        return (minute + second / 60) * 6 - 90
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: style == .thin ? 1 : 2.5)
            .fill(color)
            .frame(width: style == .thin ? 3 : (style == .classic ? 5 : 5), height: style == .thin ? 65 : 70)
            .shadow(color: .black.opacity(0.4), radius: 2)
            .offset(y: style == .thin ? -32.5 : -35)
            .rotationEffect(.degrees(minuteAngle))
    }
}

struct SecondHand: View {
    let time: Date
    let color: Color
    let style: HandStyle
    
    var secondAngle: Double {
        let calendar = Calendar.current
        let second = Double(calendar.component(.second, from: time))
        return second * 6 - 90
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(color)
            .frame(width: style == .classic ? 3 : 2, height: style == .thin ? 75 : 80)
            .shadow(color: .black.opacity(0.3), radius: 1)
            .offset(y: style == .thin ? -37.5 : -40)
            .rotationEffect(.degrees(secondAngle))
    }
}

#Preview {
    ContentView()
}

// MARK: - Settings Management

struct WidgetSettings: Codable {
    var imageScale: Double
    var imageOffsetX: Double
    var imageOffsetY: Double
    var showBorder: Bool
    var borderColor: CodableColor
    var borderWidth: Double
    var showDayNumber: Bool
    var dayNumberSize: Double
    var dayNumberOffsetX: Double
    var dayNumberOffsetY: Double
    var dayNumberFont: DayFont
    var dayNumberColor: CodableColor
    var hourHandColor: CodableColor
    var minuteHandColor: CodableColor
    var secondHandColor: CodableColor
    var handStyle: HandStyle
    
    init(imageScale: Double, imageOffsetX: Double, imageOffsetY: Double,
         showBorder: Bool, borderColor: Color, borderWidth: Double,
         showDayNumber: Bool, dayNumberSize: Double, dayNumberOffsetX: Double, dayNumberOffsetY: Double,
         dayNumberFont: DayFont, dayNumberColor: Color, hourHandColor: Color,
         minuteHandColor: Color, secondHandColor: Color, handStyle: HandStyle) {
        self.imageScale = imageScale
        self.imageOffsetX = imageOffsetX
        self.imageOffsetY = imageOffsetY
        self.showBorder = showBorder
        self.borderColor = CodableColor(color: borderColor)
        self.borderWidth = borderWidth
        self.showDayNumber = showDayNumber
        self.dayNumberSize = dayNumberSize
        self.dayNumberOffsetX = dayNumberOffsetX
        self.dayNumberOffsetY = dayNumberOffsetY
        self.dayNumberFont = dayNumberFont
        self.dayNumberColor = CodableColor(color: dayNumberColor)
        self.hourHandColor = CodableColor(color: hourHandColor)
        self.minuteHandColor = CodableColor(color: minuteHandColor)
        self.secondHandColor = CodableColor(color: secondHandColor)
        self.handStyle = handStyle
    }
}

struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(color: Color) {
        let nsColor = NSColor(color).usingColorSpace(.deviceRGB) ?? NSColor.white
        self.red = Double(nsColor.redComponent)
        self.green = Double(nsColor.greenComponent)
        self.blue = Double(nsColor.blueComponent)
        self.opacity = Double(nsColor.alphaComponent)
    }
    
    func toColor() -> Color {
        return Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

class WidgetSettingsManager {
    private let defaults = UserDefaults.standard
    private let settingsKey = "WidgetSettings"
    private let backgroundImagePathKey = "BackgroundImagePath"
    
    func saveSettings(_ settings: WidgetSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> WidgetSettings? {
        if let data = defaults.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(WidgetSettings.self, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveBackgroundImagePath(_ path: String) {
        defaults.set(path, forKey: backgroundImagePathKey)
    }
    
    func loadBackgroundImagePath() -> String? {
        return defaults.string(forKey: backgroundImagePathKey)
    }
}



















