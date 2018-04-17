Changelog
===

master
---

v0.8.0
---

- Renamed gem to `rt_health_monitor`.  The directory names are still the same,
  so you don't have to change your `require`s yet.
- Refactored HealthMonitor middleware
- The middleware now returns 503 instead of 200 if one of the checks failed.

v0.7.2
---

* Require sidekiq/api to be able to use Sidekiq::ProcessSet

v0.7.1
---

* Fix scoping issue

v0.7.0
---

* Restructured the gem, added sidekiq health check task
