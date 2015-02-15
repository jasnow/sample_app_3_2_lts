# Be sure to restart your server when you modify this file.

# RAILS 4.0: SampleApp31::Application.config.session_store :upgrade_signature_to_encryption_cookie_store, key: '_sample_app_3_2_lts_session'
# Rails 3.2.x:
SampleApp31::Application.config.session_store :cookie_store, key: '_sample_app_3_2_lts_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# SampleApp31::Application.config.session_store :active_record_store


