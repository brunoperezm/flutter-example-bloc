import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hell/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to hasConnection',
      () async {
        final tHasConnection = Future.value(true);
        // arrange
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnection);
        // act
        final result = networkInfoImpl.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnection);
      },
    );
  });
}
