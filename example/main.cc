#include "base/at_exit.h"
#include "base/bind.h"
#include "base/command_line.h"
#include "base/threading/sequenced_task_runner_handle.h"

#include "base/message_loop/message_loop.h"

void SayHello() {
  printf("Hello World.\n");
  base::SequencedTaskRunnerHandle::Get()->PostDelayedTask(
      FROM_HERE, base::BindOnce(SayHello),
      base::TimeDelta::FromMilliseconds(500));
}

int main(int argc, char** argv) {
  base::CommandLine::Init(0, 0);
  base::AtExitManager at_exit;
  base::MessageLoopForUI message_loop;
  base::SequencedTaskRunnerHandle::Get()->PostDelayedTask(
      FROM_HERE, base::BindOnce(SayHello),
      base::TimeDelta::FromMilliseconds(500));
  base::RunLoop run_loop;
  run_loop.Run();
  return 0;
}