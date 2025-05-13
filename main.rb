require 'date'
require 'fileutils'
require 'set'

def move_file(file, target_folder, dry_run, summary)
  return if dry_run

  unless Dir.exist?(target_folder)
    FileUtils.mkdir_p(target_folder)
    summary[:folders_created] << target_folder
  end

  destination = File.join(target_folder, file)
  # If the file wiht same name exists, create new filename with time stamp
  if File.exist?(destination)
    base = File.basename(file, ".*")
    ext = File.extname(file)
    new_name = "#{base}_#{Time.now.to_i}#{ext}"
    destination = File.join(target_folder, new_name)
  end

  FileUtils.mv(file, destination)
  summary[:files_moved] += 1
end

def print_file_names(files, print_all)
  return unless print_all
  files.each { |f| puts "    #{f}" }
end

dry_run = false
print_all_files = false

month_names = ["Tammikuu", "Helmikuu", "Maaliskuu", "Huhtikuu", "Toukokuu", "Kesäkuu",
               "Heinäkuu", "Elokuu", "Syyskuu", "Lokakuu", "Marraskuu", "Joulukuu"]

quarter_names = ["Tammikuu-Maaliskuu", "Huhtikuu-Kesäkuu", "Heinäkuu-Syyskuu", "Lokakuu-Joulukuu"]

summary = {
  files_moved: 0,
  folders_created: Set.new
}

files_per_year_month = Hash.new { |h, y| h[y] = Hash.new { |k, m| k[m] = [] } }

# Get all files from the script directory, excluding the script itself and target folders
script_name = File.basename($0)
excluded_paths = [script_name, ".git", ".gitignore", ".vscode"]

Dir.glob("**/*", File::FNM_DOTMATCH)
   .select do |f|
     File.file?(f) &&
     !excluded_paths.any? { |e| f.start_with?(e) } &&
     f !~ %r{^\d{4}/}  # skip files already inside year-named folders
   end
   .each do |file|
     time = File.mtime(file)
     year = time.year
     month = time.month
     files_per_year_month[year][month] << file
   end


files_per_year_month.each do |year, month_hash|
  puts "Vuosi #{year}:"

  yearly_files = month_hash.values.flatten
  if yearly_files.size < 10
    puts "  (alle 10 tiedostoa – sijoitetaan suoraan #{year}/ kansioon)"
    yearly_files.each do |file|
      move_file(file, year.to_s, dry_run, summary)
    end
    print_file_names(yearly_files, print_all_files)
    next
  end

  quarter_map = {
    0 => (1..3).to_a,
    1 => (4..6).to_a,
    2 => (7..9).to_a,
    3 => (10..12).to_a
  }

  quarter_map.each do |i, months|
    group = months & month_hash.keys  # Only months that are present in the data
    next if group.empty?

    all_files = group.flat_map { |m| month_hash[m] }

    if all_files.size < 15
      puts "  #{quarter_names[i]}: #{all_files.size} tiedostoa (→ yhdistetty kansio)"
      print_file_names(all_files, print_all_files)
      all_files.each do |file|
        move_file(file, File.join(year.to_s, quarter_names[i]), dry_run, summary)
      end
    else
      group.each do |month|
        files = month_hash[month]
        next if files.empty?
        puts "  #{month_names[month - 1]}: #{files.size} tiedostoa"
        print_file_names(files, print_all_files)
        files.each do |file|
          move_file(file, File.join(year.to_s, month_names[month - 1]), dry_run, summary)
        end
      end
    end
  end
end

puts "\nYhteenveto:"
puts "Siirrettyjä tiedostoja: #{summary[:files_moved]}"
puts "Luotuja kansioita: #{summary[:folders_created].size}"
