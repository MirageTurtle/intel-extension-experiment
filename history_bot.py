from intel_extension_for_transformers.neural_chat import PipelineConfig
from intel_extension_for_transformers.neural_chat import build_chatbot
from intel_extension_for_transformers.neural_chat import plugins
from intel_extension_for_transformers.transformers import RtnConfig


plugins.retrieval.enable=False
plugins.retrieval.args['embedding_model'] = "./bge-base-zh-v1.5"
plugins.retrieval.args["input_path"] = "./history_24/baihuasanguozhi.txt"
plugins.retrieval.args["persist_directory"] = "./history_24"
plugins.retrieval.args["collection_name"] = "baihuasanguozhi"

config = PipelineConfig(
    model_name_or_path='./chatglm3-6b',
    plugins=plugins,
    optimization_config=RtnConfig(compute_dtype="int8", weight_dtype="int4_fullrange")
)

chatbot = build_chatbot(config)

while True:
    try:
        query = input("User: ")
    except KeyboardInterrupt:
        print("\nExiting...")
        break
    except UnicodeDecodeError:
        print("UnicodeDecodeError! Please try again.")
        continue
    if query == "exit":
        break
    response = chatbot.predict(query=query)
    print(f"Bot: {response}")
