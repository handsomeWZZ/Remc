#pragma once

#include <memory>

#include "Remc/Core/PlatformDetection.h"

// DLL support
#ifdef REMC_PLATFORM_WINDOWS
		#if REMC_DYNAMIC_LINK
				#ifdef REMC_BUILD_DLL
						#define REMC_API __declspec(dllexport)
				#else
						#define REMC_API __declspec(dllimport)
				#endif
		#else
				#define REMC_API
		#endif
#else
		#error Remc only supports Windows!
#endif // End of DLL support

#ifdef REMC_DEBUG
	#if defined(REMC_PLATFORM_WINDOWS)
		#define REMC_DEBUGBREAK() __debugbreak()
	#elif defined(REMC_PLATFORM_LINUX)
		#include <signal.h>
		#define REMC_DEBUGBREAK() raise(SIGTRAP)
	#else
		#error "Platform doesn't support debugbreak yet!"
	#endif
	#define REMC_ENABLE_ASSERTS
#else
	#define HZ_DEBUGBREAK()
#endif

// TODO: Make this macro able to take in no arguments except condition
#ifdef REMC_ENABLE_ASSERTS
	#define REMC_ASSERT(x, ...) { if(!(x)) { REMC_ERROR("Assertion Failed: {0}", __VA_ARGS__); REMC_DEBUGBREAK(); } }
	#define REMC_CORE_ASSERT(x, ...) { if(!(x)) { REMC_CORE_ERROR("Assertion Failed: {0}", __VA_ARGS__); REMC_DEBUGBREAK(); } }
#else
	#define REMC_ASSERT(x, ...)
	#define REMC_CORE_ASSERT(x, ...)
#endif

#define BIT(x) (1 << x)

#define REMC_BIND_EVENT_FN(fn) [this](auto&&... args) -> decltype(auto) { return this->fn(std::forward<decltype(args)>(args)...); }

namespace Remc
{

	template<typename T>
	using Scope = std::unique_ptr<T>;
	template<typename T, typename ... Args>
	constexpr Scope<T> CreateScope(Args&& ... args)
	{
		return std::make_unique<T>(std::forward<Args>(args)...);
	}

	template<typename T>
	using Ref = std::shared_ptr<T>;
	template<typename T, typename ... Args>
	constexpr Ref<T> CreateRef(Args&& ... args)
	{
		return std::make_shared<T>(std::forward<Args>(args)...);
	}

}