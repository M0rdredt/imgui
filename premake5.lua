workspace "Gmay"
    startproject "Sandbox"
    architecture "x64"
    
    configurations
    {
        "DEBUG",
        "RELEASE",
        "DIST"
    }
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}
IncludeDir["GLFW"] = "Gmay/vendor/GLFW/include"
IncludeDir["Glad"] = "Gmay/vendor/Glad/include"
IncludeDir["ImGui"] = "Gmay/vendor/imgui"
IncludeDir["glm"] = "Gmay/vendor/glm"

group "Dependencies"
    include "Gmay/vendor/GLFW"
    include "Gmay/vendor/Glad"
    include "Gmay/vendor/imgui"
group ""



project "Gmay"
    location "Gmay"
    kind "SharedLib"
    language "C++"
    staticruntime "off"
    
    targetdir ("bin/"..outputdir.."/%{prj.name}")
    objdir ("bin-int/"..outputdir.."/%{prj.name}")
    
    pchheader "gmpch.h"
    pchsource "Gmay/src/gmpch.cpp"
    
    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/vendor/glm/glm/**.hpp",
        "%{prj.name}/vendor/glm/glm/**.inl"
    }
    includedirs
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}",
        "%{IncludeDir.glm}"
    }
    links
    {
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }
    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"
        
        defines
        {
            "GM_PLATFORM_WINDOWS",
            "GM_BUILD_DLL",
            "GLFW_INCLUDE_NONE"
        }
        
        postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} \"../bin/"..outputdir.."/Sandbox/\"")
        }
        
    filter "configurations:Debug"
        defines "GM_DEBUG"
        runtime "Debug"
        symbols "On"
    
    filter "configurations:Release"
        defines "GM_RELEASE"
        runtime "Release"
        optimize "On"
        
    filter "configurations:Dist"
        defines "GM_DIST"
        runtime "Release"
        optimize "On"
        
project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    staticruntime "off"

    
    targetdir ("bin/"..outputdir.."/%{prj.name}")
    objdir ("bin-int/"..outputdir.."/%{prj.name}")
    
    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }
    includedirs
    {
        "Gmay/vendor/spdlog/include",
        "Gmay/src",
        "%{IncludeDir.glm}"
    }
    
    links
    {
        "Gmay"
    }
    
    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"
        
        defines
        {
            "GM_PLATFORM_WINDOWS"
        }
        
    filter "configurations:Debug"
        defines "GM_DEBUG"
        runtime "Debug"
        symbols "On"
    
    filter "configurations:Release"
        defines "GM_RELEASE"
        runtime "Release"
        optimize "On"
        
    filter "configurations:Dist"
        defines "GM_DIST"
        runtime "Release"
        optimize "On"