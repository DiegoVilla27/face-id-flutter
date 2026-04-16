// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authTypeHash() => r'0bedcc7fc15aba669dfb3db870d728159ed34d7e';

/// See also [authType].
@ProviderFor(authType)
final authTypeProvider = AutoDisposeFutureProvider<AppAuthType>.internal(
  authType,
  name: r'authTypeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthTypeRef = AutoDisposeFutureProviderRef<AppAuthType>;
String _$biometricServiceHash() => r'4d552df63d0c24c79cc4cccb10b4f91375bc03c6';

/// See also [BiometricService].
@ProviderFor(BiometricService)
final biometricServiceProvider =
    AutoDisposeNotifierProvider<BiometricService, void>.internal(
  BiometricService.new,
  name: r'biometricServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$biometricServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BiometricService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
