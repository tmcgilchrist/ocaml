module L = Linear

module Subrange_state = Inlined_frames.Subrange_state
module Subrange_info = Inlined_frames.Subrange_info
module Range_info = Inlined_frames.Range_info
include Compute_ranges.Make (Inlined_frames)
