#!/bin/bash
env="Overcooked"

# asymmetric_advantages coordination_ring counter_circuit_o_1order=random3, cramped_room forced_coordination=random0
layout=counter_circuit_o_1order # asymmetric_advantages diverse_counter_circuit_6x5

num_agents=2
algo="population"
pop="${layout}_mep" # asymmetric_advantages_fcp diverse_shaped_pop
exp="${pop}_${0##*/}"
seed_max=1

path=./overcooked_population
population_yaml_path=${path}/pop_data/${pop}/pop_for_vae_config.yml

export POLICY_POOL=${path}

echo "env is ${env}, layout is ${layout}, algo is ${algo}, exp is ${exp}, max seed is ${seed_max}"
for seed in `seq ${seed_max}`
do
    echo "seed is ${seed}:"
    CUDA_VISIBLE_DEVICES=$1 python overcooked_population/create_dataset.py --env_name ${env} --algorithm_name ${algo} --experiment_name ${exp} --layout_name ${layout} --num_agents ${num_agents} \
        --seed ${seed} --n_training_threads 1 --n_rollout_threads 200 --episode_length 400 --reward_shaping_horizon 0 \
        --cnn_layers_params "32,3,1,1 64,3,1,1 32,3,1,1" --log_inerval 1 \
        --population_yaml_path ${population_yaml_path} \
        --total_trajectories 100000 \
        --dataset_file "../../../overcooked_dataset/${pop}/dataset.hdf5" \
        --use_wandb
done
