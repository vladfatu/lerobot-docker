# LeRobot on RunPod

## 1. Build & push the image

```bash
chmod +x build_and_push.sh
./build_and_push.sh <your-dockerhub-username>
```

## 2. Create a RunPod pod

1. Go to [RunPod](https://runpod.io) → **Pods** → **+ New Pod**
2. Select your GPU (RTX 4090 / A100 / H100)
3. Set **Container Image** to `<your-dockerhub-username>/lerobot-runpod:latest`
4. Set **Container Disk** to at least 30 GB
5. Launch and connect via SSH or web terminal

## 3. Run training

```bash
lerobot-train --config-name=act_pusht_real --steps=20000 --save_freq=2000
```

### With W&B tracking

```bash
wandb login

lerobot-train --config-name=act_pusht_real --steps=20000 --save_freq=2000 --wandb.enable=true --wandb.project=lerobot-training
```

### With a private HuggingFace dataset

```bash
hf auth login

lerobot-train --config-name=act_pusht_real --dataset_repo_id=your-org/your-dataset
```

## 4. Tips

- Checkpoints are saved to `./outputs/train/<run_name>/checkpoints/` — mount a RunPod volume to persist them across restarts.
- To resume a run: add `--resume=true --hydra.run.dir=./outputs/train/<your-run-name>`
- List all available configs: `lerobot-train --help`
