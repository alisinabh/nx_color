if System.get_env("USE_EXLA") do
  EXLA.set_as_nx_default([:tpu, :cuda, :rocm, :host])
end

ExUnit.start()
