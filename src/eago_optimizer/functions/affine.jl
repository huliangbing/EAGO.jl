"""
$(TYPEDEF)

"""
struct AffineFunctionIneq <: AbstractEAGOConstraint
    terms::Vector{Tuple{Float64,Int}}
    constant::Float64
    len::Int
end

function lower_interval_bound(f::AffineFunctionIneq, y::NodeBB)

    terms = f.terms
    lo_bnds = y.lower_variable_bounds
    up_bnds = y.upper_variable_bounds

    lower_interval_bound = f.constant
    for i = 1:f.len
        coeff, indx = @inbounds terms[k]
        if coeff > 0.0
            lvb = @inbounds lo_bnds[indx]
            lower_interval_bound += coeff*lvb
        else
            uvb = @inbounds up_bnds[indx]
            lower_interval_bound += coeff*uvb
        end
    end

    return lower_interval_bound
end


"""
$(TYPEDEF)

"""
struct AffineFunctionEq <: AbstractEAGOConstraint
    terms::Vector{Tuple{Float64,Int}}
    constant::Float64
end

function interval_bound(f::AffineFunctionEq, y::NodeBB)
    terms = f.terms
    lo_bnds = y.lower_variable_bounds
    up_bnds = y.upper_variable_bounds

    lower_interval_bound = f.constant
    upper_interval_bound = f.constant
    for i = 1:f.len
        coeff, indx = @inbounds terms[k]
        lvb = @inbounds lo_bnds[indx]
        uvb = @inbounds up_bnds[indx]
        if coeff > 0.0
            lower_interval_bound += coeff*lvb
            upper_interval_bound += coeff*uvb
        else
            lower_interval_bound += coeff*uvb
            upper_interval_bound += coeff*lvb
        end
    end

    return lower_interval_bound, upper_interval_bound
end
