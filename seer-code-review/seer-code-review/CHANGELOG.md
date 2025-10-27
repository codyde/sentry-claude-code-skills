# Changelog

All notable changes to the seer-reviewer skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-18

### Added
- Initial release of seer-reviewer skill
- 5-phase workflow for analyzing seer-by-sentry comments
- Priority matrix based on severity × confidence scores
- Automatic validation of bot-identified issues
- Structured fix implementation with git workflow
- Detailed reporting format
- Quick reference guide
- Comprehensive documentation

### Features
- Fetch and parse PR comments from GitHub
- Validate issues by checking actual code context
- Assess risk using severity and confidence metrics
- Implement fixes with proper git branch management
- Generate detailed commit messages
- Handle common issue types (path errors, race conditions, etc.)
- Identify and document false positives
- Support for multiple PR workflows

### Documentation
- Complete SKILL.md with workflow instructions
- README.md with usage examples
- QUICKREF.md for quick command lookup
- MIT License
