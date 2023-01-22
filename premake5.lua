workspace "Remc"
	architecture "x64"
	startproject "Sandbox"

	configurations
	{
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Remc/vendor/GLFW/include"
IncludeDir["Glad"] = "Remc/vendor/Glad/include"
IncludeDir["ImGui"] = "Remc/vendor/imgui"
IncludeDir["glm"] = "Remc/vendor/glm"

group "Dependencies"
	include "Remc/vendor/GLFW"
	include "Remc/vendor/GLad"
	include "Remc/vendor/imgui"

group ""

project "Remc"
	location "Remc"
	kind "StaticLib"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "rcpch.h"
	pchsource "Remc/src/rcpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl",
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
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
		systemversion "latest"

		defines
		{
			"REMC_PLATFORM_WINDOWS",
			"REMC_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}

	filter "configurations:Debug"
		defines "REMC_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "REMC_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "REMC_DIST"
		runtime "Release"
		optimize "on"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Remc/vendor/spdlog/include",
		"Remc/src",
		"Remc/vendor",
		"%{IncludeDir.glm}"
	}

	links
	{
		"Remc"
	}

	filter "system:windows"
		systemversion "latest"

		defines
		{
			"REMC_PLATFORM_WINDOWS"
		}

	filter "configurations:Debug"
		defines "REMC_DEBUG"
		runtime "Debug"
		symbols "on"

	filter "configurations:Release"
		defines "REMC_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Dist"
		defines "REMC_DIST"
		runtime "Release"
		optimize "on"
