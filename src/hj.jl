function _explore(
    f::FType,
    base::Vector{Float64},
    step::Float64,
) where {FType<:Function}
    point = copy(base)
    fpoint = f(point)

    for i = 1:length(point)
        plus = copy(point)
        plus[i] += step
        fplus = f(plus)
        if fplus < fpoint
            point = plus
            fpoint = fplus
            continue
        end

        minus = copy(point)
        minus[i] -= step
        fminus = f(minus)
        if fminus < fpoint
            point = minus
            fpoint = fminus
        end
    end

    return point, fpoint
end

function hj(
    f::FType,
    par::Vector{Float64};
    maxiter = 1000,
    startstep = 5.0,
    endstep = 0.0001,
) where {FType<:Function}
    currentstep = startstep
    base = copy(par)
    fbase = f(base)
    iter::Int64 = 0

    while iter < maxiter
        explored, fexplored = _explore(f, base, currentstep)
        iter += 1

        if fexplored < fbase
            previousbase = base
            base = explored
            fbase = fexplored

            while iter < maxiter
                pattern = base .+ (base .- previousbase)
                exploredpattern, fexploredpattern = _explore(f, pattern, currentstep)
                iter += 1

                if fexploredpattern < fbase
                    previousbase = base
                    base = exploredpattern
                    fbase = fexploredpattern
                else
                    break
                end
            end
        else
            currentstep /= 2
        end

        if currentstep < endstep
            break
        end
    end

    return Dict("par" => base, "iter" => iter, "step" => currentstep)
end
