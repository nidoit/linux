#!/usr/bin/env julia

using Dates

# Packages to check (add or remove as needed)
const PACKAGES = [
    "alsa-lib",
    "xf86-video-amdgpu",
    "apparmor",
    "apt",
    "bash",
    "bind",
    "chromium",
    "cinnamon",
    "cups",
    "e2fsprogs",
    "ffmpeg",
    "firefox",
    "flatpak",
    "freetype2",
    "gcc",
    "gimp",
    "git",
    "glibc",
    "gnome-shell",
    "grub",
    "gtk4",
    "httpd",
    "inkscape",
    "kmod",
    "krita",
    "libreoffice-fresh",
    "libreoffice-still",
    "libselinux",
    "linux",
    "mariadb",
    "mate-desktop",
    "mesa",
    "mysql",
    "nautilus",
    "nvidia-utils",
    "jdk-openjdk",
    "openssh",
    "openssl",
    "perl",
    "php",
    "plasma-desktop",
    "postfix",
    "postgresql",
    "python",
    "qt6-base",
    "samba",
    "systemd",
    "thunderbird",
    "vim",
    "vlc",
    "wayland",
    "xfdesktop",
    "xorg-server",
]

# Distribution info to manually set
const DISTRO_INFO = Dict(
    "release_date" => "2026-02-08",
    "eol" => "Never",
    "price_usd" => "Free",
    "image_size_mb" => "3~5Gb",
    "download" => "ISO",
    "installer" => "Archiso",
    "default_desktop" => "KDE",
    "default_browser" => "Falkon",
    "package_manager" => "Pacman",
    "release_model" => "Rolling",
    "office_suite" => "LibreOffice",
    "architecture" => "x86_64",
    "init_system" => "systemd",
    "filesystem" => "ext4",
    "multilingual" => "Yes",
    "asian_language" => "CJK",
    "package_list" => "--",
)

# Packages with alternatives (check first one, if not found check alternatives)
# Format: "primary_package" => ["alternative1", "alternative2", ...]
const PACKAGE_ALTERNATIVES = Dict(
    "libreoffice-fresh" => ["libreoffice-still"],
    "jdk-openjdk" => ["jre-openjdk", "java-runtime"],
    "nvidia-utils" => ["nvidia-open", "nvidia"],
    "linux" => ["linux-lts", "linux-zen", "linux-hardened"],
)

# Package name to display name mapping
const DISPLAY_NAMES = Dict(
    "alsa-lib" => "alsa-lib",
    "xf86-video-amdgpu" => "amdgpu",
    "apparmor" => "apparmor",
    "apt" => "apt",
    "bash" => "bash",
    "bind" => "bind",
    "chromium" => "chromium",
    "cinnamon" => "cinnamon",
    "cups" => "cups",
    "e2fsprogs" => "e2fsprogs",
    "ffmpeg" => "ffmpeg",
    "firefox" => "firefox",
    "flatpak" => "flatpak",
    "freetype2" => "freetype",
    "gcc" => "gcc",
    "gimp" => "gimp",
    "git" => "git",
    "glibc" => "glibc",
    "gnome-shell" => "gnome-shell",
    "grub" => "grub",
    "gtk4" => "gtk",
    "httpd" => "httpd",
    "inkscape" => "inkscape",
    "kmod" => "kmod",
    "krita" => "krita",
    "libreoffice-fresh" => "LibreOffice",
    "libreoffice-still" => "LibreOffice",
    "libselinux" => "libselinux",
    "linux" => "linux",
    "mariadb" => "mariadb",
    "mate-desktop" => "mate-desktop",
    "mesa" => "mesa",
    "mysql" => "mysql",
    "nautilus" => "nautilus",
    "nvidia-utils" => "NVIDIA",
    "jdk-openjdk" => "openjdk",
    "openssh" => "openssh",
    "openssl" => "openssl",
    "perl" => "perl",
    "php" => "php",
    "plasma-desktop" => "plasma-desktop",
    "postfix" => "postfix",
    "postgresql" => "postgresql",
    "python" => "Python",
    "qt6-base" => "qt",
    "samba" => "samba",
    "systemd" => "systemd",
    "thunderbird" => "thunderbird",
    "vim" => "vim",
    "vlc" => "vlc",
    "wayland" => "wayland",
    "xfdesktop" => "xfdesktop",
    "xorg-server" => "xorg-server",
)

function get_distro_name()::String
    try
        os_release = read("/etc/os-release", String)
        for line in split(os_release, '\n')
            if startswith(line, "NAME=")
                return replace(strip(split(line, '=')[2]), "\"" => "")
            end
        end
    catch
    end
    return "--"
end

function get_distro_id()::String
    try
        os_release = read("/etc/os-release", String)
        for line in split(os_release, '\n')
            if startswith(line, "ID=")
                return replace(strip(split(line, '=')[2]), "\"" => "")
            end
        end
    catch
    end
    return "--"
end

function get_package_version(pkg::String)::Union{String, Nothing}
    try
        result = read(`pacman -Q $pkg`, String)
        parts = split(strip(result))
        return length(parts) >= 2 ? String(parts[2]) : nothing
    catch
        return nothing
    end
end

function clean_version(version::String)::String
    # Remove epoch prefix (e.g., "1:4.20.3-1" -> "4.20.3-1")
    if contains(version, ":")
        version = split(version, ":")[end]
    end
    
    # Remove everything from + or - onwards (e.g., "15.2.1+r447..." -> "15.2.1")
    for sep in ['+', '-']
        if contains(version, sep)
            version = split(version, sep)[1]
        end
    end
    
    return version
end

function get_system_info()::Dict{String, String}
    info = Dict{String, String}()
    
    # Hostname
    try
        info["hostname"] = strip(read(`hostname`, String))
    catch
        info["hostname"] = ""
    end
    
    # Kernel version
    try
        info["kernel"] = strip(read(`uname -r`, String))
    catch
        info["kernel"] = ""
    end
    
    # Architecture
    try
        info["architecture"] = strip(read(`uname -m`, String))
    catch
        info["architecture"] = ""
    end
    
    # OS info from /etc/os-release
    try
        os_release = read("/etc/os-release", String)
        for line in split(os_release, '\n')
            if startswith(line, "NAME=")
                info["os_name"] = replace(strip(split(line, '=')[2]), "\"" => "")
            elseif startswith(line, "ID=")
                info["os_id"] = replace(strip(split(line, '=')[2]), "\"" => "")
            end
        end
    catch
    end
    
    return info
end

function escape_toml_string(s::String)::String
    return replace(s, "\\" => "\\\\", "\"" => "\\\"")
end

function generate_toml()::String
    lines = String[]
    
    push!(lines, "# System Package Versions")
    push!(lines, "# Generated: $(Dates.format(now(), "yyyy-mm-dd HH:MM:SS"))")
    push!(lines, "")
    
    # Distribution info section
    push!(lines, "[info]")
    push!(lines, "distro_name = \"$(get_distro_name())\"")
    push!(lines, "distro_id = \"$(get_distro_id())\"")
    push!(lines, "release_date = \"$(DISTRO_INFO["release_date"])\"")
    push!(lines, "eol = \"$(DISTRO_INFO["eol"])\"")
    push!(lines, "price_usd = \"$(DISTRO_INFO["price_usd"])\"")
    push!(lines, "image_size_mb = \"$(DISTRO_INFO["image_size_mb"])\"")
    push!(lines, "download = \"$(DISTRO_INFO["download"])\"")
    push!(lines, "installer = \"$(DISTRO_INFO["installer"])\"")
    push!(lines, "default_desktop = \"$(DISTRO_INFO["default_desktop"])\"")
    push!(lines, "default_browser = \"$(DISTRO_INFO["default_browser"])\"")
    push!(lines, "package_manager = \"$(DISTRO_INFO["package_manager"])\"")
    push!(lines, "release_model = \"$(DISTRO_INFO["release_model"])\"")
    push!(lines, "office_suite = \"$(DISTRO_INFO["office_suite"])\"")
    push!(lines, "architecture = \"$(DISTRO_INFO["architecture"])\"")
    push!(lines, "init_system = \"$(DISTRO_INFO["init_system"])\"")
    push!(lines, "filesystem = \"$(DISTRO_INFO["filesystem"])\"")
    push!(lines, "multilingual = \"$(DISTRO_INFO["multilingual"])\"")
    push!(lines, "asian_language = \"$(DISTRO_INFO["asian_language"])\"")
    push!(lines, "package_list = \"$(DISTRO_INFO["package_list"])\"")
    push!(lines, "")
    
    # Packages section
    push!(lines, "[packages]")
    
    # Track which display names we've already output
    done_display_names = Set{String}()
    
    for pkg in PACKAGES
        # Get display name
        display_name = get(DISPLAY_NAMES, pkg, pkg)
        
        # Skip if we've already output this display name
        if display_name in done_display_names
            continue
        end
        
        # Try to get version for this package
        version = get_package_version(pkg)
        
        # If not found and has alternatives, try them
        if version === nothing && haskey(PACKAGE_ALTERNATIVES, pkg)
            for alt_pkg in PACKAGE_ALTERNATIVES[pkg]
                version = get_package_version(alt_pkg)
                if version !== nothing
                    break
                end
            end
        end
        
        # Mark this display name as done
        push!(done_display_names, display_name)
        
        # Sanitize for TOML key (replace - with _)
        toml_key = replace(display_name, "-" => "_")
        if version !== nothing
            push!(lines, "$toml_key = \"$(escape_toml_string(clean_version(version)))\"")
        else
            push!(lines, "$toml_key = \"--\"")
        end
    end
    
    return join(lines, "\n")
end

function main()
    output_file = length(ARGS) >= 1 ? ARGS[1] : "system_versions.toml"
    
    println("Scanning installed packages...")
    toml_content = generate_toml()
    
    write(output_file, toml_content)
    println("Generated: $output_file")
    println()
    println(toml_content)
end

main()
