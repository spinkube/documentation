---
title: Advice for new contributors
description: Are you a contributor and not sure what to do? Want to help but just don't know how to get started? This is the section for you.
weight: 1
aliases:
- /docs/contrib/feedback
- /docs/spin-operator/support/feedback
---

This page contains more general advice on ways you can contribute to SpinKube, and how to approach
that.

If you are looking for a reference on the details of making code contributions, see the [Writing
code]({{< ref "writing-code" >}}) documentation.

## First steps

Start with these steps to be successful as a contributor to SpinKube.

### Join the conversation

It can be argued that collaboration and communication are the most crucial aspects of open source
development. Gaining consensus on the direction of the project, and that your work is aligned with
that direction, is key to getting your work accepted. This is why it is important to join the
conversation early and often.

To join the conversation, visit the `#spinkube` channel on the [CNCF
Slack](https://cloud-native.slack.com/archives/C06PC7JA1EE).

### Read the documentation

The SpinKube documentation is a great place to start. It contains information on how to get started
with the project, how to contribute, and how to use the project. The documentation is also a great
place to find information on the project's architecture and design.

SpinKube's documentation is great but it is not perfect. If you find something that is unclear or
incorrect, please submit a pull request to fix it. See the guide on [writing documentation]({{< ref
"writing-documentation" >}}) for more information.

### Triage issues

If an issue reports a bug, try and reproduce it. If you can reproduce it and it seems valid, make a
note that you confirmed the bug. Make sure the issue is labeled properly. If you cannot reproduce
the bug, ask the reporter for more information.

### Write tests

Consider writing a test for the bug's behavior, even if you don't fix the bug itself.

issues labeled `good first issue` are a great place to start. These issues are specifically tagged
as being good for new contributors to work on.

## Guidelines

As a newcomer on a large project, it's easy to experience frustration. Here's some advice to make
your work on SpinKube more useful and rewarding.

### Pick a subject area that you care about, that you are familiar with, or that you want to learn about

You don't already have to be an expert on the area you want to work on; you become an expert through
your ongoing contributions to the code.

### Start small

It's easier to get feedback on a little issue than on a big one, especially as a new contributor;
the maintainters are more likely to have time to review a small change.

### If you're going to engage in a big task, make sure that your idea has support first

This means getting someone else to confirm that a bug is real before you fix the issue, and ensuring
that there's consensus on a proposed feature before you go implementing it.

### Be bold! Leave feedback!

Sometimes it can be scary to put your opinion out to the world and say "this issue is correct" or
"this patch needs work", but it's the only way the project moves forward. The contributions of the
broad SpinKube community ultimately have a much greater impact than that of any one person. We can't
do it without you!

### Err on the side of caution when marking things ready for review

If you're really not certain if a pull request is ready for review, don't mark it as such. Leave a
comment instead, letting others know your thoughts. If you're mostly certain, but not completely
certain, you might also try asking on [Slack](https://cloud-native.slack.com/archives/C06PC7JA1EE)
to see if someone else can confirm your suspicions.

### Wait for feedback, and respond to feedback that you receive

Focus on one or two issues, see them through from start to finish, and repeat. The shotgun approach
of taking on lots of issues and letting some fall by the wayside ends up doing more harm than good.

### Be rigorous

When we say "this pull request must have documentation and tests", we mean it. If a patch doesn't
have documentation and tests, there had better be a good reason. Arguments like "I couldn't find any
existing tests of this feature" don't carry much weight; while it may be true, that means you have
the extra-important job of writing the very first tests for that feature, not that you get a pass
from writing tests altogether.

### Be patient

It's not always easy for your issue or your patch to be reviewed quickly. This isn't personal. There
are a lot of issues and pull requests to get through.

Keeping your patch up to date is important. Review the pull request on GitHub to ensure that you've
addressed all review comments.
