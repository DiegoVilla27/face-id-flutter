// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isBiometricsEnabledHash() =>
    r'5457c2478771e12d165accd61e8692615a8731a8';

/// See also [isBiometricsEnabled].
@ProviderFor(isBiometricsEnabled)
final isBiometricsEnabledProvider = AutoDisposeProvider<bool>.internal(
  isBiometricsEnabled,
  name: r'isBiometricsEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isBiometricsEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsBiometricsEnabledRef = AutoDisposeProviderRef<bool>;
String _$authNotifierHash() => r'ad3345351abfb0ffc159dc5722f95a0ccbebf911';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, AsyncValue<AuthStatus>>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeNotifier<AsyncValue<AuthStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
