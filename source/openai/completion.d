/**
OpenAI API Completions

Standards: https://platform.openai.com/docs/api-reference/completions
*/
module openai.completion;

import mir.algebraic;
import mir.serde;
import mir.string_map;
import std.math;

import openai.common;

@safe:

///
struct CompletionRequest
{
    ///
    @serdeIgnoreDefault
    string model;

    ///
    string prompt;

    ///
    @serdeIgnoreDefault
    string suffix = null;

    ///
    @serdeIgnoreDefault
    Nullable!int logProbs = null;

    ///
    @serdeIgnoreDefault
    @serdeKeys("max_tokens")
    uint maxTokens = 16;

    ///
    @serdeIgnoreDefault
    double temperature = 1;

    ///
    @serdeIgnoreDefault
    double topP = 1;

    ///
    @serdeIgnoreDefault
    uint n = 1;

    ///
    @serdeIgnoreDefault
    bool stream = false;

    ///
    @serdeIgnoreDefault
    bool echo = false;

    ///
    @serdeIgnoreDefault
    StopToken stop = null;

    ///
    @serdeIgnoreDefault
    @serdeIgnoreOutIf!isNaN double presencePenalty = 0;

    ///
    @serdeIgnoreDefault
    double frequencyPenalty = 0;

    ///
    @serdeIgnoreDefault
    uint bestOf = 1;

    // Reason: mir-algorithm's JsonAlgebraic does not support associative arrays with int or uint keys.
    // @serdeIgnoreDefault
    // @serdeKeys("logit_bias")
    // float[int] logitBias;

    ///
    @serdeIgnoreDefault
    string user = null;
}

/**
 * Convenience helper that constructs a `CompletionRequest` for the
 * `/completions` endpoint.
 *
 * Params:
 *     model        = ID of the model or deployment.
 *     prompt       = Text prompt sent to the model.
 *     maxTokens    = Maximum tokens to generate (defaults to 16 in
 *                    `CompletionRequest`).
 *     temperature  = Sampling temperature (defaults to `1.0`).
 *
 * Returns: a populated request that can be passed to
 *          `OpenAIClient.completion`.
 */
CompletionRequest completionRequest(string model, string prompt, uint maxTokens, double temperature)
{
    auto request = CompletionRequest();
    request.model = model;
    request.prompt = prompt;
    request.maxTokens = maxTokens;
    request.temperature = temperature;
    return request;
}

///
@serdeIgnoreUnexpectedKeys
struct PromptTokensDetails
{
    ///
    @serdeKeys("cached_tokens")
    uint cachedTokens;

    ///
    @serdeKeys("audio_tokens")
    uint audioTokens;
}

///
@serdeIgnoreUnexpectedKeys
struct CompletionTokensDetails
{
    ///
    @serdeKeys("reasoning_tokens")
    uint reasoningTokens;

    ///
    @serdeKeys("audio_tokens")
    uint audioTokens;

    ///
    @serdeKeys("accepted_prediction_tokens")
    uint acceptedPredictionTokens;

    ///
    @serdeKeys("rejected_prediction_tokens")
    uint rejectedPredictionTokens;
}

///
@serdeIgnoreUnexpectedKeys
struct CompletionUsage
{
    ///
    @serdeKeys("prompt_tokens")
    uint promptTokens;

    ///
    @serdeKeys("completion_tokens")
    @serdeOptional
    uint completionTokens;

    ///
    @serdeKeys("total_tokens")
    uint totalTokens;

    ///
    @serdeKeys("prompt_tokens_details")
    @serdeOptional // for Legacy Completion API
    Nullable!PromptTokensDetails promptTokensDetails;

    ///
    @serdeKeys("completion_tokens_details")
    @serdeOptional // for Legacy Completion API
    Nullable!CompletionTokensDetails completionTokensDetails;
}

///
struct CompletionChoice
{
    ///
    string text;
    ///
    size_t index;
    ///
    @serdeKeys("logprobs")
    Nullable!double logProbs;
    ///
    @serdeKeys("finish_reason")
    string finishReason;
}

///
@serdeIgnoreUnexpectedKeys
struct CompletionResponse
{
    ///
    string id;

    ///
    string object;

    ///
    ulong created;

    ///
    string model;

    ///
    CompletionChoice[] choices;

    ///
    CompletionUsage usage;

    ///
    @serdeKeys("service_tier")
    @serdeOptional // for Legacy Completion API
    string serviceTier;

    ///
    @serdeKeys("system_fingerprint")
    @serdeOptional // for Legacy Completion API
    string systemFingerprint;
}
