defmodule Mix.Tasks.Compile.Golang do
  use Mix.Task
  require Logger
  @command "go"
  @build_command "install"
  @priv_dir "priv/native"

  def run(_args) do
    config = Mix.Project.config()
    modules = Keyword.get(config, :golang_modules, [])
    File.mkdir_p!(@priv_dir)
    Enum.map(modules, &compile_module/1)
    symlink_or_copy(config,
      Path.expand("priv"),
      Path.join(Mix.Project.app_path(config), "priv"))

    :ok
  end

  def compile_module({name, config}) do
    module_path = Keyword.get(config, :path, "native/#{name}")
    build_mode = Keyword.get(config, :mode, :release)
    Mix.shell.info "Compiling golang module #{inspect name} (#{module_path})..."
    module_full_path = Path.expand(module_path, File.cwd!)
    target_dir = Keyword.get(config, :target_dir,
      Path.join([Mix.Project.build_path(), "golang_modules", Atom.to_string(name)]))

    System.cmd(@command, [@build_command], [
      cd: module_full_path,
      stderr_to_stdout: true,
      env: [{"GOBIN", target_dir}],
      into: IO.stream(:stdio, :line),
    ])

    copy_binary_to_priv_dir(target_dir, name)
  end

  def copy_binary_to_priv_dir(target_dir, name) do
    File.cp!(
      Path.join([target_dir, Atom.to_string(name)]),
      Path.join(@priv_dir, Atom.to_string(name))
    )
  end

  # https://github.com/elixir-lang/elixir/blob/b13404e913fff70e080c08c2da3dbd5c41793b54/lib/mix/lib/mix/project.ex#L553-L562
  defp symlink_or_copy(config, source, target) do
    if config[:build_embedded] do
      if File.exists?(source) do
        File.rm_rf!(target)
        File.cp_r!(source, target)
      end
      :ok
    else
      Mix.Utils.symlink_or_copy(source, target)
    end
  end
end
