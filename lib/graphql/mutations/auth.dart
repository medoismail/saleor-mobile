const String tokenCreateMutation = r'''
  mutation TokenCreate($email: String!, $password: String!) {
    tokenCreate(email: $email, password: $password) {
      token
      refreshToken
      errors {
        field
        message
      }
      user {
        id
        email
        firstName
        lastName
      }
    }
  }
''';

const String tokenRefreshMutation = r'''
  mutation TokenRefresh($refreshToken: String!) {
    tokenRefresh(refreshToken: $refreshToken) {
      token
      errors {
        field
        message
      }
    }
  }
''';

const String accountRegisterMutation = r'''
  mutation AccountRegister($input: AccountRegisterInput!) {
    accountRegister(input: $input) {
      user {
        id
        email
        firstName
        lastName
      }
      errors {
        field
        message
      }
    }
  }
''';
