# vlx_flow

**One capability bit from GBT V8, packaged standalone.** No. 337 of 341,
`vision` domain (Vision).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **流式观察 + 两层记忆**（接自 om-ai-lab/VLX-Flow · 七步法第一步落 _upstream/VLX-Flow/）。上游当前是**纯文档仓**（Checkpoints: Coming soon）⇒ 按七步法「招一 纯逻辑直取」取它的**架构契约**、按「招三 手用我们自己的」语义那步留给自己的模型链。落点**长在现有眼上**：视觉缓存层复用 gbt_allinone/tentacle/vision_bus.py（snapshot / _ahash / diff_regions / stream_record / stream_replay）；语义记忆层**本件新增**，落 store/vision/semantic_memory.jsonl（**只追加**）。op=status/memory/timeline/recall/digest/remember（读面免门 · digest+remember 过 filesystem_write）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-vlx-flow.git
cd gbt-vlx-flow
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_vlx_flow info                  # capability card
python -m gbt_vlx_flow spec --json           # machine-readable contract
python -m gbt_vlx_flow check --payload '{}'
python -m gbt_vlx_flow run   --payload '{}'
```

Real `info` output from this machine:

```text
vlx_flow  (vision)  v1.0.0
----------------------------------------
**流式观察 + 两层记忆**（接自 om-ai-lab/VLX-Flow · 七步法第一步落 _upstream/VLX-Flow/）。上游当前是**纯文档仓**（Checkpoints: Coming soon）⇒ 按七步法「招一 纯逻辑直取」取它的**架构契约**、按「招三 手用我们自己的」语义那步留给自己的模型链。落点**长在现有眼上**：视觉缓存层复用 gbt_allinone/tentacle/vision_bus.py（snapshot / _ahash / diff_regions / stream_record / stream_replay）；语义记忆层**本件新增**，落 store/vision/semantic_memory.jsonl（**只追加**）。op=status/memory/timeline/recall/digest/remember（读面免门 · digest+remember 过 filesystem_write）

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : gbt_allinone, tentacle, vision_bus
```

Wire a real implementation:

```python
from gbt_vlx_flow import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`gbt_allinone`、`tentacle`、`vision_bus`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.09s
```

## Provenance

| field | value |
|---|---|
| capability | `vlx_flow` |
| domain | `vision` |
| handler | `vlx_flow` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [vision/vlx_flow](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/vision/vlx_flow.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
